Return-Path: <linux-kernel-owner+w=401wt.eu-S1753791AbXFUFWM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753791AbXFUFWM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 01:22:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751358AbXFUFV7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 01:21:59 -0400
Received: from mx1.redhat.com ([66.187.233.31]:40403 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751124AbXFUFV6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 01:21:58 -0400
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Neuer <mr.fred.smoothie@pobox.com>,
       Helge Hafting <helge.hafting@aitel.hist.no>,
       Daniel Hazelton <dhazelton@enter.net>,
       Chris Friesen <cfriesen@nortel.com>, Paul Mundt <lethal@linux-sh.org>,
       Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       Greg KH <greg@kroah.com>, debian developer <debiandev@gmail.com>,
       "david\@lang.hm" <david@lang.hm>, Tarkan Erimer <tarkan@netone.net.tr>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       mingo@elte.hu
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
References: <Pine.LNX.4.64.0706100150080.6675@asgard.lang.hm>
	<4671B734.1040401@nortel.com>
	<orhcpa88b0.fsf@oliva.athome.lsd.ic.unicamp.br>
	<200706142155.34298.dhazelton@enter.net>
	<or4pl96gvr.fsf@oliva.athome.lsd.ic.unicamp.br>
	<alpine.LFD.0.98.0706142034240.14121@woody.linux-foundation.org>
	<46791A35.4000009@aitel.hist.no>
	<alpine.LFD.0.98.0706200930070.3593@woody.linux-foundation.org>
	<161717d50706200958o53ae986fv635e18b9b6a17e85@mail.gmail.com>
	<alpine.LFD.0.98.0706201040590.3593@woody.linux-foundation.org>
From: Alexandre Oliva <aoliva@redhat.com>
Organization: Red Hat OS Tools Group
Date: Thu, 21 Jun 2007 02:19:32 -0300
In-Reply-To: <alpine.LFD.0.98.0706201040590.3593@woody.linux-foundation.org> (Linus Torvalds's message of "Wed\, 20 Jun 2007 11\:03\:54 -0700 \(PDT\)")
Message-ID: <orvedhrijf.fsf@oliva.athome.lsd.ic.unicamp.br>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.0.990 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Jun 20, 2007, Linus Torvalds <torvalds@linux-foundation.org> wrote:

> It allows everybody do make that choice that I consider to be really 
> important: the choice of how something _you_ designed gets used.

> And it does that exactly by *limiting* the license to only that one work. 
> Not trying to extend it past the work.

Actually, the two paragraphs above are contradictory, and the second
is not true in as much as it gives way to the former.

Consider an independent file contributed to Linux.  It is an
independent work.  But the moment it gets combined with Linux, the
only license you can use is GPLv2.

Consider a patch, or any modified version of Linux.  It's another
work.  But the license applies to it as well.

Similarly, the GPL affects patents that somehow cover the work: the
distributor can no longer enforce them against downstream users of the
software.

See?

> The GPLv3 can never do that.

It does it in just the same way that GPLv1 and GPLv2 do: "no further
restrictions".  That it has to make some of them explicit, such that
people understand they apply, or such that this provision can't be
trampled on by other laws that by default trample copyright law, is
just a legal implementation detail.

> It's missing the point that "morals" are about _personal_ choices. You 
> cannot force others to a certain moral standpoint. 

FWIW, I tend to consider morals more of a society issue than an
individual issue.  Morals encode what the society understands to be
the common good, and that's often something evolutionary, even with
biological roots.

Laws (as you say) try to reflect the morals of the society, but since
it's based on morals, it often lags behind.  Which is why some laws
become forgotten and no longer applied, even if still applicable in
theory.  And that's also why (as you alluded to in your message), when
laws actively diverge from morals, you observe a lot of civil
disobedience: think DRM, DMCA, non-benevolent dictatorships and other
abusive regimes.


I must say that it *is* lovely to watch you talk about morals in ways
that I agree so much with, even if I dissent in a some details.  This
has further increased my admiration for you.  Thank you.

-- 
Alexandre Oliva         http://www.lsd.ic.unicamp.br/~oliva/
FSF Latin America Board Member         http://www.fsfla.org/
Red Hat Compiler Engineer   aoliva@{redhat.com, gcc.gnu.org}
Free Software Evangelist  oliva@{lsd.ic.unicamp.br, gnu.org}
