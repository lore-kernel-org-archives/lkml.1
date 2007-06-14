Return-Path: <linux-kernel-owner+w=401wt.eu-S1752596AbXFNQdQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752596AbXFNQdQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 12:33:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750862AbXFNQdA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 12:33:00 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44212 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750725AbXFNQc7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 12:32:59 -0400
Date: Thu, 14 Jun 2007 09:32:24 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Kevin Fox <Kevin.Fox@pnl.gov>
cc: Daniel Hazelton <dhazelton@enter.net>, Alexandre Oliva <aoliva@redhat.com>,
       Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       Greg KH <greg@kroah.com>, debian developer <debiandev@gmail.com>,
       "david@lang.hm" <david@lang.hm>, Tarkan Erimer <tarkan@netone.net.tr>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       mingo@elte.hu
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
In-Reply-To: <1181837191.21942.24.camel@zathras.emsl.pnl.gov>
Message-ID: <alpine.LFD.0.98.0706140923250.14121@woody.linux-foundation.org>
References: <Pine.LNX.4.64.0706100150080.6675@asgard.lang.hm> 
 <alpine.LFD.0.98.0706131549000.14121@woody.linux-foundation.org> 
 <or8xanl8jg.fsf@oliva.athome.lsd.ic.unicamp.br>  <200706132042.02728.dhazelton@enter.net>
 <1181837191.21942.24.camel@zathras.emsl.pnl.gov>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 14 Jun 2007, Kevin Fox wrote:
> 
> The hardware isn't directly covered by the GPL, correct. But, if they
> want to use the software on the hardware, they have to comply with the
> GPL.

Only with the GPLv3.

Again, don't confuse the *new* requirements in the GPLv3 with any "GPL 
requirements". They didn't exist before. The kernel never signed up to 
them. They are irrelevant for the discussion.

So hardware details have *nothing* to do with compying with the GPLv2.

Could you write *another* license that puts limitations on the hardware or 
environment that you have to comply with? Sure can. And the GPLv3 does 
that. But the GPLv2 does not, and that's a fundmanetal *improvement* over 
the GPLv3 in my opinion.

Do you like licenses that force the licensee to give money back?

So why do you like licenses that force the licensee to give access to 
hardware back? It's a form of "extra compensation" that the GPLv2 never 
had. The GPLv2 talks about giving access to the *source* code. The GPLv3 
talks about giving access to the *hardware*. 

Can people really not see the difference, and why I might think it's a 
fundamental difference, and why I might choose to say that the GPLv3 is a 
worse license?

And *why* would I ever downgrade to a worse license? There had better be 
some really pressing reason to choose the worse version of the GPL. And I 
just don't find that reason in the GPLv3 itself - although, as mentioned, 
the reason could become *external* (ie I might accept a worse license it 
it comes with external code attached to it that I think makes up for the 
license deficiency).

			Linus
