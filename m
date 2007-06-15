Return-Path: <linux-kernel-owner+w=401wt.eu-S1757604AbXFOAHy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757604AbXFOAHy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 20:07:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751864AbXFOAHe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 20:07:34 -0400
Received: from sccrmhc13.comcast.net ([63.240.77.83]:61888 "EHLO
	sccrmhc13.comcast.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751099AbXFOAHd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 20:07:33 -0400
X-Greylist: delayed 301 seconds by postgrey-1.27 at vger.kernel.org; Thu, 14 Jun 2007 20:07:33 EDT
From: Jeremy Maitin-Shepard <jbms@cmu.edu>
To: Alexandre Oliva <aoliva@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Sean <seanlkml@sympatico.ca>, Adrian Bunk <bunk@stusta.de>,
       Valdis.Kletnieks@vt.edu, Daniel Hazelton <dhazelton@enter.net>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Greg KH <greg@kroah.com>,
       debian developer <debiandev@gmail.com>, david@lang.hm,
       Tarkan Erimer <tarkan@netone.net.tr>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, mingo@elte.hu
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
References: <466A3EC6.6030706@netone.net.tr>
	<200706132140.13490.dhazelton@enter.net> <20070614020827.GO3588@stusta.de>
	<200706132243.14651.dhazelton@enter.net> <20070614025640.GQ3588@stusta.de>
	<9578.1181793617@turing-police.cc.vt.edu>
	<20070614152034.GS3588@stusta.de>
	<alpine.LFD.0.98.0706140850470.14121@woody.linux-foundation.org>
	<20070614131409.9a5800dc.seanlkml@sympatico.ca>
	<alpine.LFD.0.98.0706141026150.14121@woody.linux-foundation.org>
	<orzm32cr8v.fsf@oliva.athome.lsd.ic.unicamp.br>
	<alpine.LFD.0.98.0706141153550.14121@woody.linux-foundation.org>
	<or1wgeco9v.fsf@oliva.athome.lsd.ic.unicamp.br>
	<alpine.LFD.0.98.0706141311330.14121@woody.linux-foundation.org>
	<orir9q9rgl.fsf@oliva.athome.lsd.ic.unicamp.br>
	<alpine.LFD.0.98.0706141424160.14121@woody.linux-foundation.org>
	<orps3y88ru.fsf@oliva.athome.lsd.ic.unicamp.br>
	<alpine.LFD.0.98.0706141545470.14121@woody.linux-foundation.org>
	<orzm326s3w.fsf@oliva.athome.lsd.ic.unicamp.br>
X-Habeas-SWE-9: mark in spam to <http://www.habeas.com/report/>.
X-Habeas-SWE-8: Message (HCM) and not spam. Please report use of this
X-Habeas-SWE-7: warrant mark warrants that this is a Habeas Compliant
X-Habeas-SWE-6: email in exchange for a license for this Habeas
X-Habeas-SWE-5: Sender Warranted Email (SWE) (tm). The sender of this
X-Habeas-SWE-4: Copyright 2002 Habeas (tm)
X-Habeas-SWE-3: like Habeas SWE (tm)
X-Habeas-SWE-2: brightly anticipated
X-Habeas-SWE-1: winter into spring
Date: Thu, 14 Jun 2007 20:02:24 -0400
In-Reply-To: <orzm326s3w.fsf@oliva.athome.lsd.ic.unicamp.br> (Alexandre
	Oliva's message of "Thu\, 14 Jun 2007 20\:20\:19 -0300")
Message-ID: <87r6oeytin.fsf@jbms.ath.cx>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/22.0.990 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alexandre Oliva <aoliva@redhat.com> writes:

> On Jun 14, 2007, Linus Torvalds <torvalds@linux-foundation.org> wrote:
>> On Thu, 14 Jun 2007, Alexandre Oliva wrote:
>>> 
>>> Hmm...  So, if someone takes one of the many GPLv2+ contributions and
>>> makes improvements under GPLv3+, you're going to make an effort to
>>> accept them, rather than rejecting them because they're under the
>>> GPLv3?

>> You *cannot* make GPLv3-only contributions to the kernel.

> I can make improvements to GPLv2+ files under GPLv3 (or rather will,
> after GPLv3 is published).

You can do that, but you won't be able to distribute those changes along
with the rest of the kernel.

-- 
Jeremy Maitin-Shepard
