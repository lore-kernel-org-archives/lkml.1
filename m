Return-Path: <linux-kernel-owner+w=401wt.eu-S1754717AbXFOMH2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754717AbXFOMH2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 08:07:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752910AbXFOMHQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 08:07:16 -0400
Received: from 24-75-174-210-st.chvlva.adelphia.net ([24.75.174.210]:55941
	"EHLO sanosuke.troilus.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753080AbXFOMHP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 08:07:15 -0400
To: Daniel Hazelton <dhazelton@enter.net>
Cc: Alexandre Oliva <aoliva@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       Greg KH <greg@kroah.com>, debian developer <debiandev@gmail.com>,
       "david\@lang.hm" <david@lang.hm>, Tarkan Erimer <tarkan@netone.net.tr>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       mingo@elte.hu
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
References: <Pine.LNX.4.64.0706100150080.6675@asgard.lang.hm>
	<200706142246.57583.dhazelton@enter.net>
	<878xal2a0q.fsf@graviton.dyn.troilus.org>
	<200706150127.18069.dhazelton@enter.net>
From: Michael Poole <mdpoole@troilus.org>
Date: Fri, 15 Jun 2007 08:07:14 -0400
In-Reply-To: <200706150127.18069.dhazelton@enter.net> (Daniel Hazelton's message of "Fri\, 15 Jun 2007 01\:27\:17 -0400")
Message-ID: <87sl8tzaj1.fsf@graviton.dyn.troilus.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel Hazelton writes:

> Following your logic it would be a "failure to distribute the source code for 
> a work".
>
> However, since the signing is an automated process it cannot generate a "new" 
> work - at least, not under the laws of the US - so the signature itself 
> cannot have a copyright at all.
>
> DRH
> PS: This is the exact same reason that the GPL cannot apply to a Bison 
> generated parser in the US. The "input" file that causes Bison to generate 
> the output can have a copyright, but not the output - no matter what RMS or 
> anyone else wants, and no matter what the GPL says about it.

I do not suggest that copyright subsists in the signature or in the
signing key.  Whether it does is irrelevant to the signing key being
part of the source code (when the signature is needed for the binary
to work properly).

Similarly, copyright might not subsist in a simple linker script --
its content being determined by the operating system and perhaps the
rest of the program's source code -- but under the GPL, the linker
script would be part of the source code for a compiled version.

Michael Poole
