Return-Path: <linux-kernel-owner+w=401wt.eu-S1756550AbXFOMyA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756550AbXFOMyA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 08:54:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753146AbXFOMxx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 08:53:53 -0400
Received: from 24-75-174-210-st.chvlva.adelphia.net ([24.75.174.210]:48818
	"EHLO sanosuke.troilus.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754492AbXFOMxw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 08:53:52 -0400
To: Ingo Molnar <mingo@elte.hu>
Cc: Daniel Hazelton <dhazelton@enter.net>, Alexandre Oliva <aoliva@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       Greg KH <greg@kroah.com>, debian developer <debiandev@gmail.com>,
       "david\@lang.hm" <david@lang.hm>, Tarkan Erimer <tarkan@netone.net.tr>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
References: <Pine.LNX.4.64.0706100150080.6675@asgard.lang.hm>
	<200706142246.57583.dhazelton@enter.net>
	<878xal2a0q.fsf@graviton.dyn.troilus.org>
	<200706150127.18069.dhazelton@enter.net>
	<87sl8tzaj1.fsf@graviton.dyn.troilus.org>
	<20070615124039.GB21120@elte.hu>
From: Michael Poole <mdpoole@troilus.org>
Date: Fri, 15 Jun 2007 08:53:51 -0400
In-Reply-To: <20070615124039.GB21120@elte.hu> (Ingo Molnar's message of "Fri\, 15 Jun 2007 14\:40\:39 +0200")
Message-ID: <87fy4tz8dc.fsf@graviton.dyn.troilus.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar writes:

> * Michael Poole <mdpoole@troilus.org> wrote:
>
>> > However, since the signing is an automated process it cannot 
>> > generate a "new" work - at least, not under the laws of the US - so 
>> > the signature itself cannot have a copyright at all.
> [...]
>> 
>> I do not suggest that copyright subsists in the signature or in the 
>> signing key.  Whether it does is irrelevant to the signing key being 
>> part of the source code (when the signature is needed for the binary 
>> to work properly).
>
> it is very much relevant. By admitting that the key is not part of the 
> "work", you have lost all moral basis to claim control over it.

I have not admitted any such thing.  I have said the key and signature
do not have separate copyright protection.  Variables named "i" in a
file are not protected by copyright, but they are very much part of
the source code in that file.

>> Similarly, copyright might not subsist in a simple linker script -- 
>> its content being determined by the operating system and perhaps the 
>> rest of the program's source code -- but under the GPL, the linker 
>> script would be part of the source code for a compiled version.
>
> the linker script is still part of the whole work though - even if that 
> particular element might not be copyrightable in isolation. Likewise, 
> the kernel contains code that is in the public domain - to which 
> copyright protection does not extend either. But you cannot argue that 
> the Tivo 'key' is part of the whole work. It is part of the _hardware_. 
> The Tivo box is a compilation (at most a collection) of multiple works, 
> and allowing the GPL to jump over derivation/modification lines is 
> wrong. The GPLv2 certain doesnt do that land-grab.

Where in the Tivo hardware is the signing key?  There is a related key
in the hardware, but that one is not used to generate an integral part
of the kernel binary.

Michael Poole
