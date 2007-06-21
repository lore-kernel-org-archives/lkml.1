Return-Path: <linux-kernel-owner+w=401wt.eu-S1756702AbXFUJjf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756702AbXFUJjf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 05:39:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754229AbXFUJj2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 05:39:28 -0400
Received: from mx1.redhat.com ([66.187.233.31]:34479 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754119AbXFUJj1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 05:39:27 -0400
To: linux-kernel@vger.kernel.org
Subject: how about mutual compatibility between Linux's GPLv2 and GPLv3?
From: Alexandre Oliva <aoliva@redhat.com>
Organization: Red Hat OS Tools Group
Date: Thu, 21 Jun 2007 06:39:07 -0300
Message-ID: <orlkedpryc.fsf@oliva.athome.lsd.ic.unicamp.br>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.0.990 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Here's an idea that just occurred to me, after all the discussions
about motivations, tit-for-tat, authors' wishes and all.

If GPLv3 were to have a clause that permitted combination/linking with
code under GPLv2, this wouldn't be enough for GPLv3 projects to use
Linux code, and it wouldn't be enough for Linux code to use GPLv3
projects.  That's because GPLv2 would still demand all code to be
licensed under GPLv2, and GPLv3 wouldn't permit this.

However, if GPLv3 had a permission to combine/link with code under
GPLv2, *and* Linux (and any other projects interested in mutual
compatibility) introduced an additional permission to combine/link
with code under GPLv3 (or even GPLv3+, constrained by some condition
if you will), then:

- the kernel Linux could use code from GPLv3 projects

- GPLv3 projects could use code from Linux

- each copyright holder would still get to enforce the terms s/he
  chose for his/her own code

Does this sound like something that would make sense for your
community, so as to maintain/increase cooperation between authors who
love GPLv2 and those who love defense for freedom, while respecting
each author's not-always-compatible wishes?

In other words, does it even make sense for the FSF to consider
introducing such a provision in GPLv3, that AFAICT, by itself, would
have no effect whatsoever, since an additional permission would be
needed for the GPLv2 side?


If you were to permit compatibility with GPLv3+ (rather than GPLv3),
would you constrain it?  Would something like:

  as long as the later version grants each licensee the same
  permissions as GPLv2, except for constraining permissions that would
  enable one licensee to deny other licensees the exercise of the
  permissions granted by both licenses

do, subject to translation to proper legalese (if that's at all
possible)?


Do you know of any other communities that are like-minded with you,
that are sticking with GPLv2, that I could poll about interest in such
a provision in GPLv3?


Thanks, and sorry for taking your attention away from coding one more
time.  I hope you find it worth it this time.

-- 
Alexandre Oliva         http://www.lsd.ic.unicamp.br/~oliva/
FSF Latin America Board Member         http://www.fsfla.org/
Red Hat Compiler Engineer   aoliva@{redhat.com, gcc.gnu.org}
Free Software Evangelist  oliva@{lsd.ic.unicamp.br, gnu.org}
