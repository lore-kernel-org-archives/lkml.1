Return-Path: <linux-kernel-owner+w=401wt.eu-S1760929AbXFAMV0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760929AbXFAMV0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 08:21:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758444AbXFAMVS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 08:21:18 -0400
Received: from py-out-1112.google.com ([64.233.166.178]:5776 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757945AbXFAMVQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 08:21:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:subject:x-enigmail-version:content-type:content-transfer-encoding:from;
        b=ewSLnTgdjn6Vy2wZIBsxpcm1Shl/rZskL3YOqggDL6cYfL/lniFZx6kyjmwFk9W2Ww0ABQWlVBkli5xuR3UOKL+mnpatrZE0pEB9KBvDLkwe99aqyFJnLzGMOQFmpIzgYV6OMTabH+AGnY3brB5zJQlAm4n41Ii0DLrgvbSPqhE=
Message-ID: <46600F1C.5000302@googlemail.com>
Date: Fri, 01 Jun 2007 14:20:44 +0200
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>,
       Ingo Molnar <mingo@elte.hu>,
       =?ISO-8859-2?Q?Toralf_F=F6rster?= <toralf.foerster@gmx.de>,
       linux-acpi@vger.kernel.org, Len Brown <lenb@kernel.org>,
       Thierry Volpiatto <tvolpiatt@neuf.fr>, alsa-devel@alsa-project.org,
       Jaroslav Kysela <perex@suse.cz>, Takashi Iwai <tiwai@suse.de>,
       Ben Collins <bcollins@ubuntu.com>, linux-wireless@vger.kernel.org,
       Michael Buesch <mb@bu3sch.de>,
       Maximilian Engelhardt <maxi@daemonizer.de>
Subject: [1/3] 2.6.22-rc3: known regressions v2
X-Enigmail-Version: 0.94.1.1
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 8bit
From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Here is a list of some known regressions in 2.6.22-rc3.

Feel free to add new regressions/remove fixed etc.
http://kernelnewbies.org/known_regressions



Unclassified

Subject    : build failed in function `vic_sys_interrupt'
References : http://lkml.org/lkml/2007/5/31/227
Submitter  : Toralf Förster <toralf.foerster@gmx.de>
Status     : Unknown

Subject    : long freezes on thinkpad t60
References : http://lkml.org/lkml/2007/5/24/100
Submitter  : Miklos Szeredi <miklos@szeredi.hu>
Handled-By : Ingo Molnar <mingo@elte.hu>
Status     : problem is being debugged



ACPI

Subject    : unable to shutdown on kernel 2.6.22-rc2
References : http://bugzilla.kernel.org/show_bug.cgi?id=8516
Submitter  : Thierry Volpiatto <tvolpiatt@neuf.fr>
Status     : Unknown



ALSA

Subject    : snd-aoa causes badness in lib/kref.c:33
References : http://bugzilla.kernel.org/show_bug.cgi?id=8513
Submitter  : Ben Collins <bcollins@ubuntu.com>
Status     : Unknown



Networking

Subject    : b44: regression in 2.6.22
References : http://lkml.org/lkml/2007/5/27/108
Submitter  : Maximilian Engelhardt <maxi@daemonizer.de>
Handled-By : Michael Buesch <mb@bu3sch.de>
Status     : problem is being debugged



Regards,
Michal

--
"Najbardziej brakowa³o mi twojego milczenia."
-- Andrzej Sapkowski "Co¶ wiêcej"

