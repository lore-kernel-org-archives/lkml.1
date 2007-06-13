Return-Path: <linux-kernel-owner+w=401wt.eu-S1756504AbXFMT6z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756504AbXFMT6z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 15:58:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752512AbXFMT6s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 15:58:48 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:6505 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752607AbXFMT6r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 15:58:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:subject:content-type:content-transfer-encoding:from;
        b=jbKlC/B2ynsDss7I2INZ+AZmjj49E0wPpIjizjOFcw6z0GVNa0BKOxPJx3tVkqwugwulHZgLc0MuQ4L39Rqar8VMkQ4M1WdM4wbQMhND3YjOkPLPw8FIbPBUrQq12auXLOqKQ6eX8bIi64CqIjr2s9QYzUvZlozBYAIyuF1K8JQ=
Message-ID: <46704C39.4090706@googlemail.com>
Date: Wed, 13 Jun 2007 21:57:45 +0200
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>,
       Ingo Molnar <mingo@elte.hu>, "Darrick J. Wong" <djwong@us.ibm.com>,
       Siddha Suresh B <suresh.b.siddha@intel.com>,
       Rodrigo Luiz <troops.of.doom@gmail.com>, Dave Jones <davej@redhat.com>,
       Meelis Roos <mroos@linux.ee>, Wang Zhenyu <zhen78@gmail.com>,
       Takashi Iwai <tiwai@suse.de>, Jaroslav Kysela <perex@suse.cz>,
       Ben Collins <bcollins@ubuntu.com>
Subject: [1/2] 2.6.22-rc4: known regressions v3
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Here is a list of some known regressions in 2.6.22-rc4.

Feel free to add new regressions/remove fixed etc.
http://kernelnewbies.org/known_regressions



Unclassified

Subject    : Kernel hang on CMOS_READ
References : http://lkml.org/lkml/2007/6/3/138
Submitter  : Rodrigo Luiz <troops.of.doom@gmail.com>
Status     : Unknown

Subject    : Device hang when offlining a CPU due to IRQ misrouting
References : http://lkml.org/lkml/2007/5/31/419
Submitter  : Darrick J. Wong <djwong@us.ibm.com>
Handled-By : Siddha, Suresh B <suresh.b.siddha@intel.com>
Status     : problem is being debugged

Subject    : long freezes on thinkpad t60
References : http://lkml.org/lkml/2007/5/24/100
Submitter  : Miklos Szeredi <miklos@szeredi.hu>
Handled-By : Ingo Molnar <mingo@elte.hu>
Status     : problem is being debugged



AGP

Subject    : I815 suddenly unkown to agpgart
References : http://www.uwsg.indiana.edu/hypermail/linux/kernel/0706.1/2062.html
Submitter  : Meelis Roos <mroos@linux.ee>
Handled-By : Wang Zhenyu <zhen78@gmail.com>
Status     : problem is being debugged



ALSA

Subject    : snd-aoa causes badness in lib/kref.c:33
References : http://bugzilla.kernel.org/show_bug.cgi?id=8513
Submitter  : Ben Collins <bcollins@ubuntu.com>
Handled-By : Takashi Iwai <tiwai@suse.de>
Status     : Unknown



Regards,
Michal

-- 
LOG
http://www.stardust.webpages.pl/log/
