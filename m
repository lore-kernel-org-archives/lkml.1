Return-Path: <linux-kernel-owner+w=401wt.eu-S1758010AbXFMNML@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758010AbXFMNML (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 09:12:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753382AbXFMNL6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 09:11:58 -0400
Received: from khc.piap.pl ([195.187.100.11]:54625 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752872AbXFMNL5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 09:11:57 -0400
To: Bernd Paysan <bernd.paysan@gmx.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
References: <466A3EC6.6030706@netone.net.tr> <20070612184110.GB7980@kroah.com>
	<orir9smp3u.fsf@oliva.athome.lsd.ic.unicamp.br>
	<200706131402.11396.bernd.paysan@gmx.de>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Wed, 13 Jun 2007 15:11:55 +0200
In-Reply-To: <200706131402.11396.bernd.paysan@gmx.de> (Bernd Paysan's message of "Wed, 13 Jun 2007 14:02:10 +0200")
Message-ID: <m33b0w80dg.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Bernd Paysan <bernd.paysan@gmx.de> writes:

> I want to add my two cents on what I think the legal status of the 
> individual contributions to Linux are. The thing in question is not the 
> GPLv2 itself (which is pretty clear that code without explicit statements 
> is under "any",

That's not exactly true. A work without explicit statements is not
licenced at all.

> This particular comment to how the GPL is applied to the Linux kernel 
> therefore doesn't change the GPL as such

Of course.

> Again: What Linus is entitled to do is to *select* the license under which 
> he redistributes the code downstream.

Sure.

> The GPLv2 however is very clear how the end user gets the license: from the 
> original author.

I'd be surprised if it's for GPL to decide.

> Not from the man in the middle, from a distributor or 
> kernel maintainer, who can neither add nor drop restrictions/permissions 
> (and thus the special rights of a compilation editor are void). The author 
> can only speak for himself, not by behalf of somebody else, as well as the 
> compilation editor.

How about derived works?
Am I free to get BSD source, incorporate it in GPL project, and release
the whole under GPL?
Sure, the original source stays BSD but I don't distribute it.

> That's why the FSF is so strict about having each 
> author stating copyright and the license conditions on the top of the 
> file - nobody else can.

I'm not sure the copyright laws define "files".

> So my conclusion is: If you, as contributor to the Linux kernel, want to 
> make clear that your work really is GPLv2 only, you have to do that 
> yourself, you have to add a notice like above to files where you 
> exclusively own copyright.

I don't think the law works like that.
By default you have no rights to someone's work (file or project).
The only licence I can find with Linux is GPL v2, isn't it? And even
that wasn't stated explicite until that 2.4.0something (though there
is a consensus that the COPYING file was indeed a licence for the
whole kernel).

Then you may have additional rights, such as those given in various
source files.

> The rest (the majority) did not 
> choose to say anything, which under the GPL regime means "any";

What exactly is the "GPL regime" and how is it defined by copyright
law and/or the GPL licence itself (or will of copyright holders etc.)?
-- 
Krzysztof Halasa
