Return-Path: <linux-kernel-owner+w=401wt.eu-S1751800AbXA3WY2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751800AbXA3WY2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 17:24:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751819AbXA3WY2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 17:24:28 -0500
Received: from hu-out-0506.google.com ([72.14.214.229]:17733 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751800AbXA3WY1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 17:24:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=j1Bp/SblT8RBH0s18R0HQVc1teR9Z4QGbBt3HCybgIASid3uzwnTbZauP1nxyWo1Ydlb/d3mgK9OCDceHJZnOpFcjERwKT6WvOP9WqyKDI5GZONpQ8zVuktpu3RIJnyH51DGmRHZGJ0jGcuBbL1A/VEsK4b/fcd6ObDlBBTfzPA=
Message-ID: <3d57814d0701301424m67d22cdbg7afc0a1dab29c152@mail.gmail.com>
Date: Wed, 31 Jan 2007 08:24:25 +1000
From: "Trent Waddington" <trent.waddington@gmail.com>
To: "Dave Airlie" <airlied@gmail.com>
Subject: Re: Free Linux Driver Development!
Cc: "Roland Dreier" <rdreier@cisco.com>, "Greg KH" <greg@kroah.com>,
       "Jeff Garzik" <jeff@garzik.org>, linux-kernel@vger.kernel.org
In-Reply-To: <21d7e9970701301414s251b584mbee85ecd6909febf@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070130012904.GA9617@kroah.com> <ada8xfks90x.fsf@cisco.com>
	 <20070130191020.GF20642@kroah.com> <adaodogqpmx.fsf@cisco.com>
	 <45BFA087.6020905@garzik.org> <ada4pq8qjpd.fsf@cisco.com>
	 <20070130214759.GA12477@kroah.com> <adar6tcp43r.fsf@cisco.com>
	 <21d7e9970701301414s251b584mbee85ecd6909febf@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/31/07, Dave Airlie <airlied@gmail.com> wrote:
> I'm sort of with Roland on this, the timelines aren't usually worth it
> for a company to bother especially with complicated hardware, the time
> taken to do a community graphics driver for any GPU where specs have
> been available approaches infinity, unless the vendor actually does
> the driver or pays someone to do the driver the hope of a community
> supported driver reaching maturity while the product is still
> available is slim.... for anyone desparate to start writing device
> drivers, XGI have recently dropped a load of specs for their cards,
> I'm not seeing anyone other than the usual GPU ppl step up an do
> anything and as I said the time it takes a single volunteer to write a
> GPU driver is a lot longer than the card...

All this sounds like a lack of organisation on the side of the
community to me.  Greg saying that he and others are twiddling their
thumbs because they don't know what hardware needs drivers says that
too.  Where is the list of hardware-without-drivers?  Until recently
there hasn't even been a list of hardware-with-binary-only-drivers
[1].  So anyone who has the necessary skills and thinks gee, I might
have a go at writing a linux kernel driver, has no idea where to go or
what to do.  I wonder how many vendors have a policy of just ignoring
emails from hackers asking for specifications because they have
already given the specifications to Redhat or someone else, but
hackers just keep asking them again and again.

Trent

1. see http://developer.osdl.org/dev/opendrivers/wiki/index.php/Binary_Kernel_Modules_List
for a partial list.
