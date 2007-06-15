Return-Path: <linux-kernel-owner+w=401wt.eu-S1758699AbXFOW7z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758699AbXFOW7z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 18:59:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756016AbXFOW7r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 18:59:47 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36771 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755805AbXFOW7q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 18:59:46 -0400
Date: Fri, 15 Jun 2007 15:59:14 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
cc: Daniel Hazelton <dhazelton@enter.net>, Michael Gerdau <mgd@technosis.de>,
       Alexandre Oliva <aoliva@redhat.com>,
       Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       Greg KH <greg@kroah.com>, debian developer <debiandev@gmail.com>,
       "david@lang.hm" <david@lang.hm>, Tarkan Erimer <tarkan@netone.net.tr>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
In-Reply-To: <20070615224403.GA23721@elte.hu>
Message-ID: <alpine.LFD.0.98.0706151548070.14121@woody.linux-foundation.org>
References: <Pine.LNX.4.64.0706100150080.6675@asgard.lang.hm>
 <alpine.LFD.0.98.0706150913480.14121@woody.linux-foundation.org>
 <200706160006.26428.mgd@technosis.de> <200706151830.46175.dhazelton@enter.net>
 <20070615224403.GA23721@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 16 Jun 2007, Ingo Molnar wrote:
>
> btw., still ianal, but the GPLv2 is not a "contract" but a "pure 
> copyright license".

I've been told by several independent sources that it really doesn't 
matter.

The "pure license" argument was born largely for silly reasons: people 
claimed (a _loong_ time ago) that the GPL wasn't enforceable in the US 
because in order to be enforceable, something of value has to change hands 
(in the US, for example, it would be common to "sell" something for a 
nominal sum of $1 USD rather than to give it outright, to "seal the deal" 
and make it irrevocable).

That's generally considered a specious argument, apparently. In most 
jurisdictions in the US, a license and a contract are judged to be legally 
exactly the same thing, and if you don't follow the GPL and have no other 
contract to show for it, you're in violation of federal copyright law, so 
whether it is a license or a contract really doesn't matter.

So it's true: the GPL just gives you rights, and without it you have no 
rights (other than fair use ones etc), and blah blah. But the distinction 
between "license" vs "contract" really isn't a very important one in any 
case.

> Furthermore when you get source code of free software then there is no 
> "meeting of minds" needed for you to accept the GPL's conditions, and 
> only the letter of the license (and, in case of any ambiguities, the 
> intent of the author of the code) matters to the interpretation of the 
> license, not the intent of the recipient. (while in contract cases both 
> the meeting of minds is needed and the intent and understanding of both 
> parties matters to the interpretation of the contract.)

I do agree that you can probably use this to say that the intent of the 
copyright has a stronger position, and that his "intent" thus matters 
more.

But I suspect that the "intent" angle is fairly weak legally to begin 
with, and if you cannot show that the intent was mutual, it's probably 
weaker still. So yeah, the intent of the copyright owner arguably might 
matter more, but quite frankly, I suspect everbody is better off not 
worrying so much about "intent", and worrying more about the "terms and 
conditions" part.

(I've said several times that intent _matters_, I just don't want people 
to think that it matters a whole lot).

What is pretty clear, though, is that the intent of a third party in the 
license/cotnract matters not at all. In the case of the kernel, the FSF 
being such a third party.

			Linus
