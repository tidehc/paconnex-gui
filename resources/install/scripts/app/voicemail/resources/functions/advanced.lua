--	Part of FusionPBX
--	Copyright (C) 2013 Mark J Crane <markjcrane@fusionpbx.com>
--	All rights reserved.
--
--	Redistribution and use in source and binary forms, with or without
--	modification, are permitted provided that the following conditions are met:
--
--	1. Redistributions of source code must retain the above copyright notice,
--	  this list of conditions and the following disclaimer.
--
--	2. Redistributions in binary form must reproduce the above copyright
--	  notice, this list of conditions and the following disclaimer in the
--	  documentation and/or other materials provided with the distribution.
--
--	THIS SOFTWARE IS PROVIDED ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES,
--	INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY
--	AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
--	AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY,
--	OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
--	SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
--	INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
--	CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
--	ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
--	POSSIBILITY OF SUCH DAMAGE.

--define a function for the advanced menu
	function advanced ()
		--clear the dtmf
			dtmf_digits = '';
		--flush dtmf digits from the input buffer
			session:flushDigits();
		--To record a greeting press 1
			if (session:ready()) then
				dtmf_digits = macro(session, "to_record_greeting", 1, 100, '');
			end
		--To choose greeting press 2
			if (session:ready()) then
				if (string.len(dtmf_digits) == 0) then
					dtmf_digits = macro(session, "choose_greeting", 1, 100, '');
				end
			end
		--To record your name 3
			if (session:ready()) then
				if (string.len(dtmf_digits) == 0) then
					dtmf_digits = macro(session, "to_record_name", 1, 100, '');
				end
			end
		--To change your password press 6
			if (session:ready()) then
				if (string.len(dtmf_digits) == 0) then
					dtmf_digits = macro(session, "change_password", 1, 100, '');
				end
			end
		--For the main menu press 0
			if (session:ready()) then
				if (string.len(dtmf_digits) == 0) then
					dtmf_digits = macro(session, "main_menu", 1, 5000, '');
				end
			end
		--process the dtmf
			if (session:ready()) then
				if (dtmf_digits == "1") then
					--To record a greeting press 1
					timeouts = 0;
					record_greeting(nil,"advanced");
				elseif (dtmf_digits == "2") then
					--To choose greeting press 2
					timeouts = 0;
					choose_greeting();
				elseif (dtmf_digits == "3") then
					--To record your name 3
					record_name("advanced");
				elseif (dtmf_digits == "6") then
					--To change your password press 6
					change_password(voicemail_id, "advanced");
				elseif (dtmf_digits == "0") then
					--For the main menu press 0
					timeouts = 0;
					main_menu();
				else
					timeouts = timeouts + 1;
					if (timeouts <= max_timeouts) then
						advanced();
					else
						macro(session, "goodbye", 1, 1000, '');
						session:hangup();
					end
				end
			end
	end
