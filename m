Return-Path: <linux-kernel-owner+w=401wt.eu-S1755186AbXIUDbs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755186AbXIUDbs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 23:31:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752970AbXIUDbl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 23:31:41 -0400
Received: from rex.snapgear.com ([203.143.235.140]:55534 "EHLO
	cyberguard.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751575AbXIUDbk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 23:31:40 -0400
Date: Fri, 21 Sep 2007 13:32:16 +1000
From: David McCullough <David_Mccullough@securecomputing.com>
To: Robin Getz <rgetz@blackfin.uclinux.org>
Cc: Paul Mundt <lethal@linux-sh.org>, Bernd Schmidt <bernds_cb1@t-online.de>,
       uclinux-dist-devel@blackfin.uclinux.org, bryan.wu@analog.com,
       Bernd Schmidt <bernd.schmidt@analog.com>,
       Greg Ungerer <gerg@snapgear.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, ysato@users.sourceforge.jp,
       miles@lsi.nec.co.jp, linux-m32r@ml.linux-m32r.org
Subject: Re: [PATCH] binfmt_flat: minimum support for theBlackfin relocations
Message-ID: <20070921033216.GA11139@securecomputing.com>
References: <1190102965.4406.9.camel@roc-desktop> <20070920142543.GA3268@linux-sh.org> <20070920150314.GA27079@securecomputing.com> <200709202144.16301.rgetz@blackfin.uclinux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200709202144.16301.rgetz@blackfin.uclinux.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Jivin Robin Getz lays it down ...
> On Thu 20 Sep 2007 11:03, David McCullough pondered:
> > I would say that (a) is definately not the case.  I am sure the BF guys
> > will say they have been banging us on the head with changes for a long
> > time and getting no where as we considered the changes to severe or out
> > of line.
> 
> I don't think we have been "banging heads" with you (unless that is your 
> feeling?) - how about "working together, but diverting to satisfy different 
> needs" :)

No head banging feelings here,  but I would understand if you guys felt
that way occasionally ;-)  I obviously forgot the happy face on that
statement.  It was meant as a good thing.

> I think that we have had more issues in the uClinux-dist (userspace and build 
> environment), but for kernel code, we have moved from some non-standard 
> (stupid) things we were doing early on to what we have today - which is as 
> common/standard with other archs as we can be.
> 
> Although this is slightly off topic - on the uClinux distribution side - most 
> of our changes are based on requirements/desires from being able to support 
> fdpic elf and flat formats, and to attempt to make things easier for end 
> users/us to use/maintain. Where we do make changes - we always send the patch 
> upstream and have the conversation with you (not everyone else does this), 
> and some/most times rework things so they are more acceptable to you. We 
> don't always come to an agreement - but we always have the discussion, and 
> are willing to move if we can make things better that still meets both our 
> needs/desires.
> 
> > This particular patch was trivial in comparison to others I've seen,
> 
> That is what we thought.
> 
> > it fixed all the existing arches (not something that is always done) and
> > seemed a reasonable start to finally get the BF guys up and running.
> > Still, happy to make it better of course ;-)
> 
> As always - we are more than happy to explore/review alternative patches if 
> people want to write/sumbit them.

Cheers,
Davidm

-- 
David McCullough,  david_mccullough@securecomputing.com,   Ph:+61 734352815
Secure Computing - SnapGear  http://www.uCdot.org http://www.cyberguard.com
