Return-Path: <linux-kernel-owner+w=401wt.eu-S1756594AbXFOXgS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756594AbXFOXgS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 19:36:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751553AbXFOXgI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 19:36:08 -0400
Received: from mx1.redhat.com ([66.187.233.31]:43388 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751480AbXFOXgH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 19:36:07 -0400
To: Ingo Molnar <mingo@elte.hu>
Cc: Daniel Hazelton <dhazelton@enter.net>, Michael Gerdau <mgd@technosis.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       Greg KH <greg@kroah.com>, debian developer <debiandev@gmail.com>,
       "david\@lang.hm" <david@lang.hm>, Tarkan Erimer <tarkan@netone.net.tr>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
References: <Pine.LNX.4.64.0706100150080.6675@asgard.lang.hm>
	<alpine.LFD.0.98.0706150913480.14121@woody.linux-foundation.org>
	<200706160006.26428.mgd@technosis.de>
	<200706151830.46175.dhazelton@enter.net>
	<20070615224403.GA23721@elte.hu>
From: Alexandre Oliva <aoliva@redhat.com>
Organization: Red Hat OS Tools Group
Date: Fri, 15 Jun 2007 20:34:59 -0300
In-Reply-To: <20070615224403.GA23721@elte.hu> (Ingo Molnar's message of "Sat\, 16 Jun 2007 00\:44\:03 +0200")
Message-ID: <ork5u4vljw.fsf@oliva.athome.lsd.ic.unicamp.br>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.0.990 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> * Daniel Hazelton <dhazelton@enter.net> wrote:

>> > My experience with german courts has shown me that the judges I had 
>> > to deal with always and foremost did apply a reality check and did 
>> > not try to bisect the consequences like an algorithm evaluated by a 
>> > machine, i.e. the tried to decide what is right and wrong and not 
>> > whether the letter of the contract could be twisted this or that 
>> > way.

>> This is the way it should be. However, the letter of the contract, in 
>> this case, is very clear and that hasn't stopped Herr Welte at all.

And this is the beauty of a multi-author project.  Even if some
authors think that the license permits something, if any of them
understands it doesn't, he can try to enforce that WRT his own
contributions.  So those exploiting the gray areas of the license can
still get caught.

On Jun 15, 2007, Ingo Molnar <mingo@elte.hu> wrote:

> btw., still ianal, but the GPLv2 is not a "contract" but a "pure 
> copyright license". A contract, almost by definition is a restriction of 
> rights in exchange for consideration - while if you accept the license 
> of a GPLv2-ed work this act only gives rights that you did not have 
> before.

In Brazil, this is kind of contract/license is called a beneficial
contract.

> Furthermore when you get source code of free software then there 
> is no "meeting of minds" needed for you to accept the GPL's conditions, 
> and only the letter of the license (and, in case of any ambiguities, the 
> intent of the author of the code) matters to the interpretation of the 
> license, not the intent of the recipient.

That's correct, but with a catch: since the contract or license is
chosen by the licensor, in case of ambiguity in the terms, many courts
will interpret it in a way that privileges the licensee, regardless of
the fact that copyright licenses are to be interpreted restrictively
(at least in Brazilian law).  And IANAL ;-)

-- 
Alexandre Oliva         http://www.lsd.ic.unicamp.br/~oliva/
FSF Latin America Board Member         http://www.fsfla.org/
Red Hat Compiler Engineer   aoliva@{redhat.com, gcc.gnu.org}
Free Software Evangelist  oliva@{lsd.ic.unicamp.br, gnu.org}
