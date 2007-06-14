Return-Path: <linux-kernel-owner+w=401wt.eu-S1755528AbXFNV1y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755528AbXFNV1y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 17:27:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751188AbXFNV1r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 17:27:47 -0400
Received: from mx1.redhat.com ([66.187.233.31]:48618 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750890AbXFNV1q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 17:27:46 -0400
To: Daniel Hazelton <dhazelton@enter.net>
Cc: Paul Mundt <lethal@linux-sh.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       Greg KH <greg@kroah.com>, debian developer <debiandev@gmail.com>,
       "david\@lang.hm" <david@lang.hm>, Tarkan Erimer <tarkan@netone.net.tr>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       mingo@elte.hu
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
References: <Pine.LNX.4.64.0706100150080.6675@asgard.lang.hm>
	<20070614073232.GB22543@linux-sh.org>
	<ormyz2fp8p.fsf@oliva.athome.lsd.ic.unicamp.br>
	<200706141617.46734.dhazelton@enter.net>
From: Alexandre Oliva <aoliva@redhat.com>
Organization: Red Hat OS Tools Group
Date: Thu, 14 Jun 2007 18:27:27 -0300
In-Reply-To: <200706141617.46734.dhazelton@enter.net> (Daniel Hazelton's message of "Thu\, 14 Jun 2007 16\:17\:46 -0400")
Message-ID: <or645q9qgw.fsf@oliva.athome.lsd.ic.unicamp.br>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.0.990 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Jun 14, 2007, Daniel Hazelton <dhazelton@enter.net> wrote:

> <somewhat sarcastic>
> And the companies that produce devices that come with Linux and/or
> other GPL'd software installed and place limits such that only
> people that have purchased that hardware have access to the
> "modified" source running on the device are following the letter,
> and the spirit, of the GPL.

WAIT, WAIT, THAT'S... :-)

> Before you start yelling I'm wrong, think about it this way: they
> make the source available to the people that they've given binary
> versions to, and there is nothing stopping one of those people from
> making the source available to the rest of the world.

The *only* in your sentence betrayed you.

If they place the limits such that nobody else can access the sources,
they're in violation of the license.

If they merely refrain from distributing the sources to others, but
still enable the recipients to do so, this is not a violation of the
license.

But then IANAL.

> *AND* the GPL has never been about making the source available to
> everyone - just to those that get the binaries.

Exactly.  Not even to the upstream distributor.  That's where Linus'
theory of tit-for-tat falls apart.

-- 
Alexandre Oliva         http://www.lsd.ic.unicamp.br/~oliva/
FSF Latin America Board Member         http://www.fsfla.org/
Red Hat Compiler Engineer   aoliva@{redhat.com, gcc.gnu.org}
Free Software Evangelist  oliva@{lsd.ic.unicamp.br, gnu.org}
