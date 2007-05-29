Return-Path: <linux-kernel-owner+w=401wt.eu-S1752602AbXE2MxW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752602AbXE2MxW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 08:53:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751122AbXE2MxI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 08:53:08 -0400
Received: from ug-out-1314.google.com ([66.249.92.168]:36795 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750759AbXE2MxE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 08:53:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:subject:x-enigmail-version:content-type:content-transfer-encoding:from;
        b=K3HPepSv6s9DwCLccHEg4f9tIfeGE2/NkrhqBHGuwLdBJw7ddlqOIVK+5JfqyQWvrCo3AY1H0z/4B66loAbIbfsXJRSpjTG+e/jnH1Xy7apsFaPQ900vbo+Ni7I449gx8C58oRHDK9504+yotuhHomRVNdQ0X5kgnYwvSL0HCLA=
Message-ID: <465C2225.2000100@googlemail.com>
Date: Tue, 29 May 2007 14:52:53 +0200
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>,
       Ingo Molnar <mingo@elte.hu>, linux-acpi@vger.kernel.org,
       Len Brown <lenb@kernel.org>, Thierry Volpiatto <tvolpiatt@neuf.fr>,
       alsa-devel@alsa-project.org, Takashi Iwai <tiwai@suse.de>,
       Jaroslav Kysela <perex@suse.cz>, Ben Collins <bcollins@ubuntu.com>,
       Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org,
       Florin Iucha <florin@iucha.net>, Sam Ravnborg <sam@ravnborg.org>,
       Andrey Borzenkov <arvidjaar@mail.ru>
Subject: [1/4] 2.6.22-rc3: known regressions
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



File systems

Subject    : Oops in dentry_iput with 2.6.22-rc2 on AMD64
References : http://lkml.org/lkml/2007/5/22/4
Submitter  : Florin Iucha <florin@iucha.net>
Status     : Unknown



Kbuild

Subject    : make M=$PWD modules_install does nothing
References : http://lkml.org/lkml/2007/5/27/190
Submitter  : Andrey Borzenkov <arvidjaar@mail.ru>
Status     : Unknown



Regards,
Michal

--
"Najbardziej brakowa³o mi twojego milczenia."
-- Andrzej Sapkowski "Co¶ wiêcej"

