Return-Path: <linux-kernel-owner+w=401wt.eu-S1755947AbXFOPxt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755947AbXFOPxt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 11:53:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753920AbXFOPxl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 11:53:41 -0400
Received: from wx-out-0506.google.com ([66.249.82.232]:8087 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753751AbXFOPxj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 11:53:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=Luowi4rNdCw7X15pMu7S6SvGCzJS6FPHujyBpR+1s/DaPIavL+3xNj21NOi3S6dxNH35icbV/EDosiHjeZ9OIDox1XVQxD+ZsmMloMyprlWKNOo5OyFEyjDxTXlNXCktkRviuxrzsr9KWosjk7qLASAlZOP2cwimZowC9gUuKR4=
Message-ID: <4672B5F6.706@gmail.com>
Date: Fri, 15 Jun 2007 11:53:26 -0400
From: Florin Malita <fmalita@gmail.com>
User-Agent: Thunderbird 2.0b2 (X11/20070116)
MIME-Version: 1.0
To: Michael Poole <mdpoole@troilus.org>
CC: Ingo Molnar <mingo@elte.hu>, Daniel Hazelton <dhazelton@enter.net>,
       Alexandre Oliva <aoliva@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       Greg KH <greg@kroah.com>, debian developer <debiandev@gmail.com>,
       "david@lang.hm" <david@lang.hm>, Tarkan Erimer <tarkan@netone.net.tr>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
References: <Pine.LNX.4.64.0706100150080.6675@asgard.lang.hm>	<200706142246.57583.dhazelton@enter.net>	<878xal2a0q.fsf@graviton.dyn.troilus.org>	<200706150127.18069.dhazelton@enter.net>	<87sl8tzaj1.fsf@graviton.dyn.troilus.org>	<20070615124039.GB21120@elte.hu>	<87fy4tz8dc.fsf@graviton.dyn.troilus.org>	<20070615143003.GA8775@elte.hu> <87zm31xo3q.fsf@graviton.dyn.troilus.org>
In-Reply-To: <87zm31xo3q.fsf@graviton.dyn.troilus.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/15/2007 10:56 AM, Michael Poole wrote:
> The GPL cares about the key
> used to generate an integral part of the executable form of the GPLed
> work.  

GLPv2 doesn't: why do you think the digital signature is an integral 
part of the executable? It can be a totally separate blob, distributed 
via a separate channel and even stored at a different location than the 
executable. Does it still look like an integral part of the executable 
to you then?

(unless of course you're trying to argue that the hash itself is a 
derivative work, but that has already been refuted many times before.)

> The executable does not function properly if it lacks that
> part.

It works just fine given the right environment. The right environment 
may be some other hardware (without DRM restrictions) or the DRMed 
device + an authorized digital signature. The digital signature is not 
part of your executable.

Do you honestly believe GPLv2 requires the distributor to provide you 
with the right environment for your modified copy to "function 
properly"? I would say it doesn't, but feel free to point me to specific 
sections which *state* otherwise. AFAICT, GPLv2 is specifically limited 
to "copying, distribution and modification". How you use (or don't use, 
or can't use) your modified copy is totally outside its scope.

---
fm

