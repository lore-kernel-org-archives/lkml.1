Return-Path: <linux-kernel-owner+w=401wt.eu-S1756258AbXFOMr7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756258AbXFOMr7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 08:47:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753780AbXFOMrv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 08:47:51 -0400
Received: from 24-75-174-210-st.chvlva.adelphia.net ([24.75.174.210]:51496
	"EHLO sanosuke.troilus.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751324AbXFOMru (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 08:47:50 -0400
To: Daniel Hazelton <dhazelton@enter.net>
Cc: Bernd Paysan <bernd.paysan@gmx.de>, david@lang.hm,
       Alexandre Oliva <aoliva@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Kevin Fox <Kevin.Fox@pnl.gov>,
       Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       Greg KH <greg@kroah.com>, debian developer <debiandev@gmail.com>,
       Tarkan Erimer <tarkan@netone.net.tr>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, mingo@elte.hu
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
References: <Pine.LNX.4.64.0706100150080.6675@asgard.lang.hm>
	<Pine.LNX.4.64.0706141643120.29630@asgard.lang.hm>
	<200706151130.11184.bernd.paysan@gmx.de>
	<200706150614.33558.dhazelton@enter.net>
From: Michael Poole <mdpoole@troilus.org>
Date: Fri, 15 Jun 2007 08:47:49 -0400
In-Reply-To: <200706150614.33558.dhazelton@enter.net> (Daniel Hazelton's message of "Fri\, 15 Jun 2007 06\:14\:33 -0400")
Message-ID: <87k5u5z8ne.fsf@graviton.dyn.troilus.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel Hazelton writes:

> On Friday 15 June 2007 05:30:09 Bernd Paysan wrote:
>> On Friday 15 June 2007 01:46, david@lang.hm wrote:
>> > if you cannot modify the software that runs on your Tivo hardware you
>> > haven't tried very hard.
>>
>> Yes, but the GPLv2 clearly says that you don't have to try very hard. The
>> preferred form of modification has to be distributed. I can run a
>> decompiler or disassembler on a program, and I can even modify it in place
>> with a hex editor (I have even modified programs in embedded ROMs by using
>> focussed ion beam, so I know you can modify every program if you try hard
>> enough). It's certainly possible to crack Tivo's firmware to accept my own
>> signature, but it's *not* the preferred form of modification, the source
>> code and Tivo's key for the signature.
>
> How is a signing key part of the "preferred form for modification"? It isn't a 
> requirement to *modify* anything, just to *replace* something. (And I am 
> *NOT* going to explain why "replace != modify" again)

The signing key determines a critical portion of the binary form that
was distributed.  You cannot produce that portion of the binary form
without the signing key.  Without that portion, the binary form does
not perform the function for which it is distributed.  If you think
such an input is not part of "the preferred form for modification", I
have a bridge to sell you.

The work that the GPL protects a recipient's right to modify and
redistribute is not the source code -- it is each form the user
receives.

>> Since Tivo's firmware only accepts a signed kernel, the combination of
>> kernel+signature is the binary they ship. The kernel itself is useless, the
>> signature as well. Therefore, you can imply that Tivo's key is part of
>> the "other stuff" the GPLv2 mentions, because you need it to recreate the
>> same code as Tivo did and shipped (compilers insert timestamps and such),
>> and to modify that code. The source code is just a mean, the thing they
>> shipped is the end (the binary), and they have to comply with the GPL for
>> that binary - which by all means of practical understanding includes the
>> signature.
>
> I can find no such requirement in the GPLv2. In fact, it actually says that 
> you don't even have to be able to *USE* the program. See section 12 of the 
> GPL if you don't believe me.

Section 12 of the GPL(v2) is a warranty and liability disclaimer.  It
is not an absolution of license obligations.  It limits the liability
of a distributor to the end user, not to copyright owners.

Michael Poole
