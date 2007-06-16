Return-Path: <linux-kernel-owner+w=401wt.eu-S1756645AbXFPMy3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756645AbXFPMy3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jun 2007 08:54:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754032AbXFPMyW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jun 2007 08:54:22 -0400
Received: from py-out-1112.google.com ([64.233.166.180]:31611 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752145AbXFPMyV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jun 2007 08:54:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ZUUOQHaD7YnstBnS6qSP2wGgsGcvZPzeWtz1oFGlCOx/YiCWga0++ybZeyagldfrzqYwf/wWJB7OfdyJXt8AA9d7mdodUGCV8w6HGYe/BWR89+WmeVMkH96NMoC2p6A15gRPIlfZ8T7//XVxj4oZGm1+MwDy21VRz//MTn0cmUs=
Message-ID: <6bffcb0e0706160554q596a3f2bx90170f3b5eda6724@mail.gmail.com>
Date: Sat, 16 Jun 2007 14:54:20 +0200
From: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
To: "Stefan Richter" <stefanr@s5r6.in-berlin.de>
Subject: Re: regression tracking (Re: Linux 2.6.21)
Cc: "Oleg Verych" <olecom@flower.upol.cz>, "Adrian Bunk" <bunk@stusta.de>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Andi Kleen" <andi@firstfloor.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Diego Calleja" <diegocg@gmail.com>,
       "Chuck Ebbert" <cebbert@redhat.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <4673D63D.5020804@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070426040806.GJ3468@stusta.de>
	 <alpine.LFD.0.98.0704290848360.9964@woody.linux-foundation.org>
	 <200704291849.23197.rjw@sisk.pl>
	 <20070429173725.GB30248@one.firstfloor.org>
	 <alpine.LFD.0.98.0704291049060.9964@woody.linux-foundation.org>
	 <E1HyipW-0005wJ-0Q@flower>
	 <alpine.LFD.0.98.0706151618380.14121@woody.linux-foundation.org>
	 <20070615234202.GP3588@stusta.de>
	 <20070616013236.GA16016@flower.upol.cz>
	 <4673D63D.5020804@s5r6.in-berlin.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stefan,

On 16/06/07, Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:
[..]
> Well, if _other_ subsystems would get regressions in Linus' tree fixed
> quicker, there might perhaps be more people who would consider to run
> -rc kernels and would catch and report "my" regressions.
[..]
>
> [Adrian, I'm not saying "too few users run -rc kernels", I'm saying "too
> few FireWire driver users run -rc kernels".]

Rafael is working on translation of "Linux Kernel Tester's Guide"
(it's almost finished). I hope you will get more -rc testers.

Regards,
Michal

-- 
LOG
http://www.stardust.webpages.pl/log/
