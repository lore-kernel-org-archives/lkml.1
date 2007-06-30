Return-Path: <linux-kernel-owner+w=401wt.eu-S1753855AbXF3Cxw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753855AbXF3Cxw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 22:53:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752534AbXF3Cxp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 22:53:45 -0400
Received: from lsd-gw.ic.unicamp.br ([143.106.7.165]:50275 "EHLO
	marquesa.lsd.ic.unicamp.br" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752365AbXF3Cxp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 22:53:45 -0400
To: davids@webmaster.com
Cc: "Linux-Kernel\@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Subject: Re: how about mutual compatibility between Linux's GPLv2 and GPLv3?
References: <MDEHLPKNGKAHNMBLJOLKCEPKEOAC.davids@webmaster.com>
From: Alexandre Oliva <oliva@lsd.ic.unicamp.br>
Date: Fri, 29 Jun 2007 23:53:30 -0300
In-Reply-To: <MDEHLPKNGKAHNMBLJOLKCEPKEOAC.davids@webmaster.com> (David Schwartz's message of "Thu\, 28 Jun 2007 12\:13\:49 -0700")
Message-ID: <orlke2885x.fsf@oliva.athome.lsd.ic.unicamp.br>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Jun 28, 2007, "David Schwartz" <davids@webmaster.com> wrote:

> Alexandre Oliva write:

>> > The GPL does sometimes use the word "may" where it's not clear
>> > whether it
>> > means you have permission or you must be able to. The general rule of
>> > construction is that "may" means permission, unless there's some clear
>> > indication to the contrary. The "may"s in sections one and two are
>> > permisssion against a claim of copyright enfrocement. The "further
>> > restriction" clause is, at it states, only on the exercise of *rights*
>> > (which I think means those rights licensed to you under copyright law,
>> > namely the right of distribution and copying).

>> ... and modification and, depending on the jurisdiction, execution.

> Modification, yes. Execution, well, if the rules of a jurisdiction are
> insane, you will get insane results from almost any contract.

> Fortunately, the GPL makes it clear that execution is unrestricted for GPL'd
> works, but does not style this as a GPL right.

Possible consequence:
http://fsfla.org/svnwiki/blogs/lxo/2007-06-29-gplv3-tivo-and-linux.en

> One would hope that jurisidictions that have such strange rules
> would interpret the GPL to effect the same result under their laws
> as was intended under the laws the GPL was written with respect to,
> to the extent possible.

Hopefully.  But we know how justice is in the US, right? :-(

> Treating ordinary use as a copyright privilege leads to nonsensical results
> no matter what you do. For example, you get that I can drop copies of my
> poem from an airplane and then sue anyone who reads it.

Who was talking about reading?  You can read programs as much as you
can read poems.  But since you (normally) can't run poems, copyright
law doesn't talk about this, just like it doesn't distinguish source
from object code of a poem.  But software is different.  So different
that it's governed by a separate law in Brazil, which could be
qualified as a subclass of copyright law.  And this law states that
running programs requires permission from the copyright holder.

If you find that odd, you may have an idea of how ludicrous patents on
software, business methods et al are.  At least copyright regulation
of execution saves us from a few abusive EULAs, created with the
purpose of, let's see, regulating execution.  And then, since it's
already there, why not use it for other restrictions beneficial to the
vendor that a copyright license couldn't establish?

-- 
Alexandre Oliva         http://www.lsd.ic.unicamp.br/~oliva/
FSF Latin America Board Member         http://www.fsfla.org/
Red Hat Compiler Engineer   aoliva@{redhat.com, gcc.gnu.org}
Free Software Evangelist  oliva@{lsd.ic.unicamp.br, gnu.org}
