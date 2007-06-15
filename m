Return-Path: <linux-kernel-owner+w=401wt.eu-S1752727AbXFOKO6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752727AbXFOKO6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 06:14:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750783AbXFOKOt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 06:14:49 -0400
Received: from keil-draco.com ([216.193.185.50]:50185 "EHLO
	mail.keil-draco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750724AbXFOKOs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 06:14:48 -0400
From: Daniel Hazelton <dhazelton@enter.net>
To: Bernd Paysan <bernd.paysan@gmx.de>
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
Date: Fri, 15 Jun 2007 06:14:33 -0400
User-Agent: KMail/1.9.6
Cc: david@lang.hm, Alexandre Oliva <aoliva@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Kevin Fox <Kevin.Fox@pnl.gov>,
       Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       Greg KH <greg@kroah.com>, debian developer <debiandev@gmail.com>,
       Tarkan Erimer <tarkan@netone.net.tr>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, mingo@elte.hu
References: <Pine.LNX.4.64.0706100150080.6675@asgard.lang.hm> <Pine.LNX.4.64.0706141643120.29630@asgard.lang.hm> <200706151130.11184.bernd.paysan@gmx.de>
In-Reply-To: <200706151130.11184.bernd.paysan@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706150614.33558.dhazelton@enter.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 15 June 2007 05:30:09 Bernd Paysan wrote:
> On Friday 15 June 2007 01:46, david@lang.hm wrote:
> > if you cannot modify the software that runs on your Tivo hardware you
> > haven't tried very hard.
>
> Yes, but the GPLv2 clearly says that you don't have to try very hard. The
> preferred form of modification has to be distributed. I can run a
> decompiler or disassembler on a program, and I can even modify it in place
> with a hex editor (I have even modified programs in embedded ROMs by using
> focussed ion beam, so I know you can modify every program if you try hard
> enough). It's certainly possible to crack Tivo's firmware to accept my own
> signature, but it's *not* the preferred form of modification, the source
> code and Tivo's key for the signature.

How is a signing key part of the "preferred form for modification"? It isn't a 
requirement to *modify* anything, just to *replace* something. (And I am 
*NOT* going to explain why "replace != modify" again)

> Since Tivo's firmware only accepts a signed kernel, the combination of
> kernel+signature is the binary they ship. The kernel itself is useless, the
> signature as well. Therefore, you can imply that Tivo's key is part of
> the "other stuff" the GPLv2 mentions, because you need it to recreate the
> same code as Tivo did and shipped (compilers insert timestamps and such),
> and to modify that code. The source code is just a mean, the thing they
> shipped is the end (the binary), and they have to comply with the GPL for
> that binary - which by all means of practical understanding includes the
> signature.

I can find no such requirement in the GPLv2. In fact, it actually says that 
you don't even have to be able to *USE* the program. See section 12 of the 
GPL if you don't believe me.

> "You can imply" means: It depends on court and legal system. I'm quite
> confident that in Germany, the legal system might favor the "GPLv2 does not
> allow tivoization" point of view, and in the USA, the legal sysem might do
> the opposite.

In light of the d-link case, I'm pretty certain that the German Courts 
interpretation of the GPLv2 makes "Tivoization" a violation. In the US I can 
say that the result would be "GPLv2 does not disallow tivoization". As I've 
pointed out in other posts, the GPLv2 actually *limits* itself to three 
specific "activities". Whether it was intended to "incidentally" cover other 
things or not, it does *clearly* state what it's scope is. If that scope *IS* 
*NOT* the intent of the person and/or person who authored the license, that 
text *SHOULD* *NOT* exist.

DRH

-- 
Dialup is like pissing through a pipette. Slow and excruciatingly painful.
