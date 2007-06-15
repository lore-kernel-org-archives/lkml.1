Return-Path: <linux-kernel-owner+w=401wt.eu-S1758757AbXFODsw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758757AbXFODsw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 23:48:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754326AbXFODsp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 23:48:45 -0400
Received: from mx1.redhat.com ([66.187.233.31]:38717 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753640AbXFODso (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 23:48:44 -0400
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Michael Poole <mdpoole@troilus.org>, Daniel Hazelton <dhazelton@enter.net>,
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
From: Alexandre Oliva <aoliva@redhat.com>
Organization: Red Hat OS Tools Group
Date: Fri, 15 Jun 2007 00:48:22 -0300
In-Reply-To: <alpine.LFD.0.98.0706142013120.14121@woody.linux-foundation.org> (Linus Torvalds's message of "Thu\, 14 Jun 2007 20\:22\:36 -0700 \(PDT\)")
Message-ID: <orps3x514p.fsf@oliva.athome.lsd.ic.unicamp.br>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.0.990 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Jun 15, 2007, Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Thu, 14 Jun 2007, Michael Poole wrote:
>> 
>> If the DRM signature and program executable are coupled such that they
>> are not useful when separated, the implication to me is that they form
>> one work that is based on the original Program.  This is beyond the
>> GPL's permission for "mere aggregation".

> So you want to make things like a 160-bit SHA1 hash of a binary be a 
> "derived work" of that software?

How about the combination of the software binary with the hash?

Considering that the hash is a functional part of the software, as in,
if you take that out, it no longer works?

> If that were to seriously be an FSF argument,

Remember: I don't speak for the FSF, and I don't speak for FSFLA, just
like I don't speak for Red Hat.

Just like you shouldn't redirect your qualms with the FSF to me, you
shouldn't direct your qualms with me to the FSF.  That would be very
wrong.

-- 
Alexandre Oliva         http://www.lsd.ic.unicamp.br/~oliva/
FSF Latin America Board Member         http://www.fsfla.org/
Red Hat Compiler Engineer   aoliva@{redhat.com, gcc.gnu.org}
Free Software Evangelist  oliva@{lsd.ic.unicamp.br, gnu.org}
