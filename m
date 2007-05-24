Return-Path: <linux-kernel-owner+w=401wt.eu-S1751159AbXEXOEU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751159AbXEXOEU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 10:04:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750735AbXEXOEG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 10:04:06 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:35582 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750716AbXEXOEC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 10:04:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:subject:x-enigmail-version:content-type:content-transfer-encoding:from;
        b=UYQayYebf45rt1g1QM8BxDsP5B2zKQDB0SIu8esFIRo0jl1b5VshQ1N5SiGb1KIFBQqcXhi3++btm80XplPOhjx4iM+J6Ki5ApXRKiiTkt5o8wuhJ84xaDOIe2torONL+mBGr2hr2SsE+8qDTfW39nXlyckGxJUIe24669nxD7s=
Message-ID: <46559B49.8020304@googlemail.com>
Date: Thu, 24 May 2007 16:03:53 +0200
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Anant Nitya <kernel@prachanda.info>, Ingo Molnar <mingo@elte.hu>,
       David Miller <davem@davemloft.net>, linux-acpi@vger.kernel.org,
       Len Brown <lenb@kernel.org>, Ray Lee <ray-lk@madrabbit.org>,
       Ben Collins <bcollins@ubuntu.com>,
       Thierry Volpiatto <tvolpiatt@neuf.fr>, alsa-devel@alsa-project.org,
       Takashi Iwai <tiwai@suse.de>, Jaroslav Kysela <perex@suse.cz>
Subject: [1/3] 2.6.22-rc2: known regressions v2
X-Enigmail-Version: 0.94.1.1
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 8bit
From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Here is a list of some known regressions in 2.6.22-rc2.

Feel free to add new regressions/remove fixed etc.
http://kernelnewbies.org/known_regressions



Unclassified

Subject    : lag problems while browsing sites with heavy JS and or flash usage
References : http://lkml.org/lkml/2007/5/19/189
Submitter  : Anant Nitya <kernel@prachanda.info>
Handled-By : Ingo Molnar <mingo@elte.hu>
             David Miller <davem@davemloft.net>
Status     : problem is being debugged



ACPI

Subject    : unable to shutdown on kernel 2.6.22-rc2
References : http://bugzilla.kernel.org/show_bug.cgi?id=8516
Submitter  : Thierry Volpiatto <tvolpiatt@neuf.fr>
Status     : Unknown

Subject    : BAT0 no longer seen, ACPI errors
References : http://bugzilla.kernel.org/show_bug.cgi?id=8493
Submitter  : Ben Collins <bcollins@ubuntu.com>
Workaround : BIOS upgrade
Status     : Unknown

Subject    : nx6125 has lost fan control
References : http://lkml.org/lkml/2007/5/16/249
Submitter  : Ray Lee <ray-lk@madrabbit.org>
Status     : Unknown



ALSA

Subject    : snd-aoa causes badness in lib/kref.c:33
References : http://bugzilla.kernel.org/show_bug.cgi?id=8513
Submitter  : Ben Collins <bcollins@ubuntu.com>
Status     : Unknown



Regards,
Michal

-- 
"Najbardziej brakowa³o mi twojego milczenia."
-- Andrzej Sapkowski "Co¶ wiêcej"

