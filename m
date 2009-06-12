Return-Path: <linux-kernel-owner+w=401wt.eu-S934753AbZFLWtn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934753AbZFLWtn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 18:49:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934597AbZFLWsr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 18:48:47 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:56016 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934634AbZFLWsp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 18:48:45 -0400
Date: Sat, 13 Jun 2009 00:48:40 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Shawn Pearce <sop@google.com>
Cc: Brian Swetland <swetland@google.com>,
       Stefan Schmidt <stefan@datenfreihafen.org>,
       Russell King - ARM Linux <linux@arm.linux.org.uk>,
       kernel list <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
       Greg KH <greg@kroah.com>
Subject: Re: Gerrit (was Re: HTC Dream aka. t-mobile g1 support)
Message-ID: <20090612224840.GG17688@elf.ucw.cz>
References: <a55d774e0906121450x12bab7b0sc1f4de0115a1af61@mail.gmail.com> <20090612222229.GE17688@elf.ucw.cz> <1cc472780906121538h5b70fa4dg891ff729fda1a566@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1cc472780906121538h5b70fa4dg891ff729fda1a566@mail.gmail.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

>    On Fri 2009-06-12 14:50:21, Brian Swetland wrote:
>    > Gerrit is a git patch review system that we (Google/Android) use for
>    > android development (kernel and otherwise).  Some other folks like
>    > Qualcomm, and TI (see [2]http://review.omapzoom.org/) have adopted it
> 
>      Unfortunately, it seems quite unsuitable for kernel.
>      Do I understand it right that to submit kernel patches I'd have to
>      agree to "contributors agreement", and give up my copyright? No,
>      sorry, I don't think I want to do that.
> 
>    No.  The contributor agreement used by [3]review.source.android.com is
>    a stronger version of the Developers Certificate of Origin normally use
>    d by kernel contributors.

So, agreeing to that is neccessary for using Gerrit? Too bad. As I
said, it is unsuitable for kernel patches.

>    For the actual agreement text see[1], but the basic principle is the
>    same.  No assignment of copyright, only assignment of license for
>    redistribution, which is what the GPL asks anyway.  It also

As I read it, it is very different from GPL.

It grants google license to do anything with that code, such as
packaging it into closed source product.

# 2. Grant of Copyright License. Subject to the terms and conditions of
# this Grant, You hereby grant to the Project Leads and to recipients of
# software distributed by the Project Leads a perpetual, worldwide,
# non-exclusive, no-charge, royalty-free, irrevocable copyright license
# to reproduce, prepare derivative works of, publicly display, publicly
# perform, sublicense, and distribute Your Contributions and such
# derivative works.

Kernel already has GPL license and Developers Certificate of Origin,
so please just use that for the kernel. (Kernel also has perfectly
working patch review system called mailing lists and git trees; please
use that, too).

>    patent provision, similar to what the Apache License contains, to
>    protect the project leads from submarine patent infringement by code
>    contributed by a patent holder.
>    [1] [4]https://review.source.android.com/static/cla_individual.html

									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
