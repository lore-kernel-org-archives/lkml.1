Return-Path: <linux-kernel-owner+w=401wt.eu-S932323AbXFEOoY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932323AbXFEOoY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 10:44:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765152AbXFEOoA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 10:44:00 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:32503 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765119AbXFEOn6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 10:43:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:subject:content-type:content-transfer-encoding:from;
        b=O21ZJ9/U/YI8PiteHJkHq0Vcbk70Pl0LwtcPAG3Ru0z1dl8OHFfncz9W+BI3UgE6cdp70eo8M1Q21YboGF2iilHwbpbv50riSMK0DyT2VG5aXUQeZjrZ3KSda0glWLmN9258Lh4+ubkoEp2BUqfzAzmMo+m64OsMsnfwaObj51U=
Message-ID: <4665769D.9090808@googlemail.com>
Date: Tue, 05 Jun 2007 16:43:41 +0200
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>,
       Ingo Molnar <mingo@elte.hu>, "Darrick J. Wong" <djwong@us.ibm.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Andi Kleen <ak@suse.de>,
       Rodrigo Luiz <troops.of.doom@gmail.com>
Subject: [1/5] 2.6.22-rc4: known regressions
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 8bit
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

Subject    : kernel BUG at arch/i386/kernel/cpu/perfctr-watchdog.c:126!
References : http://lkml.org/lkml/2007/6/3/60
Submitter  : Udo A. Steinberg <us15@os.inf.tu-dresden.de>
Status     : Unknown

Subject    : using smp_processor_id() in preemptible, in mtrr_save_state
References : http://lkml.org/lkml/2007/6/3/38
Submitter  : Rafael J. Wysocki <rjw@sisk.pl>
Status     : Unknown

Subject    : Device hang when offlining a CPU due to IRQ misrouting
References : http://lkml.org/lkml/2007/5/31/419
Submitter  : Darrick J. Wong <djwong@us.ibm.com>
Status     : Unknown

Subject    : long freezes on thinkpad t60
References : http://lkml.org/lkml/2007/5/24/100
Submitter  : Miklos Szeredi <miklos@szeredi.hu>
Handled-By : Ingo Molnar <mingo@elte.hu>
Status     : problem is being debugged



Regards,
Michal

--
"Najbardziej brakowa³o mi twojego milczenia."
-- Andrzej Sapkowski "Co¶ wiêcej"
