Return-Path: <linux-kernel-owner+w=401wt.eu-S1758723AbXFNXV5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758723AbXFNXV5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 19:21:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755216AbXFNXVu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 19:21:50 -0400
Received: from mx1.redhat.com ([66.187.233.31]:58435 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753362AbXFNXVt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 19:21:49 -0400
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Sean <seanlkml@sympatico.ca>, Adrian Bunk <bunk@stusta.de>,
       Valdis.Kletnieks@vt.edu, Daniel Hazelton <dhazelton@enter.net>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Greg KH <greg@kroah.com>,
       debian developer <debiandev@gmail.com>, david@lang.hm,
       Tarkan Erimer <tarkan@netone.net.tr>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, mingo@elte.hu
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
References: <466A3EC6.6030706@netone.net.tr>
	<200706132140.13490.dhazelton@enter.net>
	<20070614020827.GO3588@stusta.de>
	<200706132243.14651.dhazelton@enter.net>
	<20070614025640.GQ3588@stusta.de>
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
From: Alexandre Oliva <aoliva@redhat.com>
Organization: Red Hat OS Tools Group
Date: Thu, 14 Jun 2007 20:20:19 -0300
In-Reply-To: <alpine.LFD.0.98.0706141545470.14121@woody.linux-foundation.org> (Linus Torvalds's message of "Thu\, 14 Jun 2007 15\:52\:02 -0700 \(PDT\)")
Message-ID: <orzm326s3w.fsf@oliva.athome.lsd.ic.unicamp.br>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.0.990 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Jun 14, 2007, Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Thu, 14 Jun 2007, Alexandre Oliva wrote:
>> 
>> Hmm...  So, if someone takes one of the many GPLv2+ contributions and
>> makes improvements under GPLv3+, you're going to make an effort to
>> accept them, rather than rejecting them because they're under the
>> GPLv3?

> You *cannot* make GPLv3-only contributions to the kernel.

I can make improvements to GPLv2+ files under GPLv3 (or rather will,
after GPLv3 is published).  And you wrote:

> I want to be able to use other peoples improvements. If they release
> improved versions of the software I started, I want to be able to
> merge those improvements if I want to.

So which is it?  Do you want to be able to use other people's
improvements, respecting the conditions you said they are legitimately
entitled to make, or is this not quite the whole story?

> But not within the confines of the Linux kernel. Within the Linux kernel, 
> the GPLv2 rules - and "GPLv2+" becomes just "GPLv2", since the GPLv3 is 
> not compatible with v2.

I understand this very well.  You'd have to get the kernel upgraded to
GPLv3 in order to accept the contribution.

Likewise for any other contribution under any other GPLv2-incompatible
license.

So, you see, your statement above, about wanting to be able to use
other people's improvements, cannot be taken without qualification.

-- 
Alexandre Oliva         http://www.lsd.ic.unicamp.br/~oliva/
FSF Latin America Board Member         http://www.fsfla.org/
Red Hat Compiler Engineer   aoliva@{redhat.com, gcc.gnu.org}
Free Software Evangelist  oliva@{lsd.ic.unicamp.br, gnu.org}
