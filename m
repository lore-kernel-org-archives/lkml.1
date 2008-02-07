Return-Path: <linux-kernel-owner+w=401wt.eu-S1760819AbYBGTEs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760819AbYBGTEs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 14:04:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756811AbYBGTEh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 14:04:37 -0500
Received: from senator.holtmann.net ([87.106.208.187]:51730 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756615AbYBGTEf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 14:04:35 -0500
Subject: Re: [PATCH] USB: mark USB drivers as being GPL only
From: Marcel Holtmann <marcel@holtmann.org>
To: David Newall <davidn@davidnewall.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, Greg KH <greg@kroah.com>,
       Christer Weinigel <christer@weinigel.se>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <47AB0A76.3000404@davidnewall.com>
References: <20080125180232.GA4613@kroah.com>
	 <20080202123710.42df1aa0@weinigel.se> <20080202191930.GA19826@kroah.com>
	 <47A5D9CD.5070001@davidnewall.com>
	 <84144f020802030743j1278ac64j2ee3e2cbc5c3fefc@mail.gmail.com>
	 <47A5E67D.9040804@davidnewall.com>
	 <84144f020802030848v160253feoa24c5ecefc7c91f5@mail.gmail.com>
	 <courier.47A8497B.0000472E@hawking.rebel.net.au>
	 <1202240590.15090.119.camel@violet>  <47AB0A76.3000404@davidnewall.com>
Content-Type: text/plain
Date: Thu, 07 Feb 2008 20:05:13 +0100
Message-Id: <1202411113.15090.263.camel@violet>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

> >>> I think you're missing my point: as long as the license stays the way
> >>> it is now, you can never distribute proprietary code unless you've
> >>> consulted a lawyer and even then you run the risk of being sued for
> >>> infringement if the copyright holder thinks what you have is derived
> >>> work.
> >>>       
> >> Yes I can, if the proprietary code is not linked with GPL code (and the 
> >> proprietary code is original).  Loadable modules are not linked.  This is a 
> >> very clear-cut case.
> >>     
> >
> > that is not clear-cut case. You link at run-time. Otherwise the module
> > would do nothing.
> 
> That's why it's allowed.  The module isn't linked when it's distributed,
> and the author doesn't do or cause the linking; the user does.  And the
> user never distributes in the linked state.  Distribution is key to GPL.

so how do you build this module that is not linked without using the
Linux kernel. Hence derivative work. Hence dynamic linking at runtime of
binary only code is violating the GPL.

Same goes for dynamic linking at runtime against GPL libraries. Nobody
thinks that is possible and ships binary applications that link against
GPL libaries. So why do you think you can distribute a binary only
kernel module.

Regards

Marcel


