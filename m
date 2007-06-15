Return-Path: <linux-kernel-owner+w=401wt.eu-S1756686AbXFODcN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756686AbXFODcN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 23:32:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752066AbXFODb7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 23:31:59 -0400
Received: from 24-75-174-210-st.chvlva.adelphia.net ([24.75.174.210]:55509
	"EHLO sanosuke.troilus.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751749AbXFODb6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 23:31:58 -0400
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Daniel Hazelton <dhazelton@enter.net>, Alexandre Oliva <aoliva@redhat.com>,
       Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       Greg KH <greg@kroah.com>, debian developer <debiandev@gmail.com>,
       "david\@lang.hm" <david@lang.hm>, Tarkan Erimer <tarkan@netone.net.tr>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       mingo@elte.hu
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
References: <Pine.LNX.4.64.0706100150080.6675@asgard.lang.hm>
	<200706142049.41819.dhazelton@enter.net>
	<87fy4u0xty.fsf@graviton.dyn.troilus.org>
	<200706142246.57583.dhazelton@enter.net>
	<878xal2a0q.fsf@graviton.dyn.troilus.org>
	<alpine.LFD.0.98.0706142013120.14121@woody.linux-foundation.org>
From: Michael Poole <mdpoole@troilus.org>
Date: Thu, 14 Jun 2007 23:31:57 -0400
In-Reply-To: <alpine.LFD.0.98.0706142013120.14121@woody.linux-foundation.org> (Linus Torvalds's message of "Thu\, 14 Jun 2007 20\:22\:36 -0700 \(PDT\)")
Message-ID: <874pl928r6.fsf@graviton.dyn.troilus.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds writes:

> On Thu, 14 Jun 2007, Michael Poole wrote:
>>
>> If the DRM signature and program executable are coupled such that they
>> are not useful when separated, the implication to me is that they form
>> one work that is based on the original Program.  This is beyond the
>> GPL's permission for "mere aggregation".
>
> So you want to make things like a 160-bit SHA1 hash of a binary be a 
> "derived work" of that software?

No.  That is why I specified "not useful when separated".  I also
intentionally avoided the phrase "derived work": the legal definition
of derived work is based on entirely different factors.

If the signature is one that serves to indicate origin, to detect
tampering, or the other things you mentioned, the program's binary is
useful when separated from the signature.  My objection arises when a
functionally equivalent binary -- including advertised functions such
as "runs on platform XYZ" -- cannot be produced from the distributed
source code.

Michael Poole
