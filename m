Return-Path: <linux-kernel-owner+w=401wt.eu-S1760867AbYBGT07@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760867AbYBGT07 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 14:26:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757157AbYBGT0t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 14:26:49 -0500
Received: from senator.holtmann.net ([87.106.208.187]:48517 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756173AbYBGT0s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 14:26:48 -0500
Subject: Re: [PATCH] USB: mark USB drivers as being GPL only
From: Marcel Holtmann <marcel@holtmann.org>
To: Diego Zuccato <diego@otello.alma.unibo.it>
Cc: Christer Weinigel <christer@weinigel.se>,
       David Newall <davidn@davidnewall.com>, Greg KH <greg@kroah.com>,
       linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <47AABC4A.7010105@otello.alma.unibo.it>
References: <20080125180232.GA4613@kroah.com>
	 <20080202123710.42df1aa0@weinigel.se>	<20080202191930.GA19826@kroah.com>
	 <47A5D895.20300@davidnewall.com>	<47A6E742.80408@otello.alma.unibo.it>
	 <47A764ED.8030605@weinigel.se>	<1202161091.15090.84.camel@violet>
	 <20080206213449.6614efea@weinigel.se>
	 <1202331345.15090.235.camel@violet.holtmann.net>
	 <20080206222937.2aa69a2e@weinigel.se>
	 <47AABC4A.7010105@otello.alma.unibo.it>
Content-Type: text/plain
Date: Thu, 07 Feb 2008 20:27:26 +0100
Message-Id: <1202412446.15090.271.camel@violet>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Diego,

> > I think it is perfectly within their rights to do so.  I think it's
> > kind of silly to try to hide it, if someone wants to boost the maximum
> > transmit power, they're going to hack the firmware anyway.  But if it
> > makes Intel happy, well... :-)
> And break the HW :-) Actually, they could be happier, since then you 
> have to buy another...
> 
> [...]
> > preliminary go ahead from the bosses to provide documentation under an
> > NDA to Linux developers that would like to write GPL drivers for it.  I
> [...]
> Urgh... I don't think NDAs and Open Source mix well... Are you sure your 
> bosses KNOW Linux and the OS in general? :-)

talk to Greg KH about this. Have NDAs and open source work together is
really simple. Have the NDA say that you can use all provided
documentation to write an open source driver and publish it under GPL. A
lot of companies are okay with this these days. The Linux Foundation
should have NDA template texts for this.

Regards

Marcel


