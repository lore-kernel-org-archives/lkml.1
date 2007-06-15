Return-Path: <linux-kernel-owner+w=401wt.eu-S1755754AbXFOAR3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755754AbXFOAR3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 20:17:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752197AbXFOARW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 20:17:22 -0400
Received: from alnrmhc15.comcast.net ([204.127.225.95]:37361 "EHLO
	alnrmhc15.comcast.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750878AbXFOARV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 20:17:21 -0400
From: Jeremy Maitin-Shepard <jbms@cmu.edu>
To: Carlo Wood <carlo@alinoe.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Alexandre Oliva <aoliva@redhat.com>, Adrian Bunk <bunk@stusta.de>,
       Valdis.Kletnieks@vt.edu, Daniel Hazelton <dhazelton@enter.net>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Greg KH <greg@kroah.com>,
       debian developer <debiandev@gmail.com>, david@lang.hm,
       Tarkan Erimer <tarkan@netone.net.tr>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, mingo@elte.hu
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
In-Reply-To: <20070614231812.GA9463@alinoe.com> (Carlo Wood's message of "Fri\,
	15 Jun 2007 01\:18\:12 +0200")
References: <20070614020827.GO3588@stusta.de>
	<200706132243.14651.dhazelton@enter.net> <20070614025640.GQ3588@stusta.de>
	<9578.1181793617@turing-police.cc.vt.edu>
	<20070614152034.GS3588@stusta.de>
	<alpine.LFD.0.98.0706140850470.14121@woody.linux-foundation.org>
	<orwsy6e89s.fsf@oliva.athome.lsd.ic.unicamp.br>
	<alpine.LFD.0.98.0706141100390.14121@woody.linux-foundation.org>
	<ork5u6cpc2.fsf@oliva.athome.lsd.ic.unicamp.br>
	<alpine.LFD.0.98.0706141304210.14121@woody.linux-foundation.org>
	<20070614231812.GA9463@alinoe.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/22.0.990 (gnu/linux)
X-Habeas-SWE-9: mark in spam to <http://www.habeas.com/report/>.
X-Habeas-SWE-8: Message (HCM) and not spam. Please report use of this
X-Habeas-SWE-7: warrant mark warrants that this is a Habeas Compliant
X-Habeas-SWE-6: email in exchange for a license for this Habeas
X-Habeas-SWE-5: Sender Warranted Email (SWE) (tm). The sender of this
X-Habeas-SWE-4: Copyright 2002 Habeas (tm)
X-Habeas-SWE-3: like Habeas SWE (tm)
X-Habeas-SWE-2: brightly anticipated
X-Habeas-SWE-1: winter into spring
Date: Thu, 14 Jun 2007 20:16:57 -0400
Message-ID: <87k5u6ysue.fsf@jbms.ath.cx>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Carlo Wood <carlo@alinoe.com> writes:

> On Thu, Jun 14, 2007 at 01:09:46PM -0700, Linus Torvalds wrote:
>> I'm the original author, and I selected the GPLv2 for Linux.
> [...]
>> I'm not going to bother discussing this any more. You don't seem to 
>> respect my right to choose the license for my own code.

> This is the main reason I dislike GPLwhatever: there is no notion
> of "orginal author". You might have written 99% of the code, that
> doesn't matter. You have no rights whatsoever once you release
> something under the GPL (no more than ANYOne else).

You retain the copyright, and in particular the right to relicense.
Only if you make the mistake of including the "or any later version"
phrase do you allow others to redistribute the work under a different
version of the GPL.  Although this provision may seem slightly
convenient to authors, its effect is to grant a very large amount of
relicensing permission to the FSF.  It almost certainly doesn't make
sense to place that much trust in a single organization.

> The GPL is nice for the community, and for the users - but very,
> very bad towards it's authors (taking all and every right you might
> have). If John Doe wants to re-release the whole kernel under
> GPLv3, then all he needs is a website and some bandwidth.

Well, he also needs one tiny little extra thing: the permission of every
copyright holder in Linux.

-- 
Jeremy Maitin-Shepard
