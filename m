Return-Path: <linux-kernel-owner+w=401wt.eu-S1751934AbXA3WOw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751934AbXA3WOw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 17:14:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751905AbXA3WOv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 17:14:51 -0500
Received: from ug-out-1314.google.com ([66.249.92.172]:41972 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751914AbXA3WOu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 17:14:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=iP9lBJUEa1FE2TNGyvh2UwgJnnr39srk5BMhpGe8NTUgW1m+IvXdx3oBghMUU3Uh9RtfO3zZ5SLiivN+q5dDUADwPaKSCKoJXGm+5CEa8QPMQ+DaTsVoWMijwdSUWtJGLDxTFSIDrg4xZBy9ToItyW4ZMXsNWp7P0k1l+bRmgPI=
Message-ID: <21d7e9970701301414s251b584mbee85ecd6909febf@mail.gmail.com>
Date: Wed, 31 Jan 2007 09:14:44 +1100
From: "Dave Airlie" <airlied@gmail.com>
To: "Roland Dreier" <rdreier@cisco.com>
Subject: Re: Free Linux Driver Development!
Cc: "Greg KH" <greg@kroah.com>, "Jeff Garzik" <jeff@garzik.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <adar6tcp43r.fsf@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070130012904.GA9617@kroah.com> <ada8xfks90x.fsf@cisco.com>
	 <20070130191020.GF20642@kroah.com> <adaodogqpmx.fsf@cisco.com>
	 <45BFA087.6020905@garzik.org> <ada4pq8qjpd.fsf@cisco.com>
	 <20070130214759.GA12477@kroah.com> <adar6tcp43r.fsf@cisco.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>  > There was a wireless-mini-summit a week or so ago, so those developers
>  > all know what is going on in that space right now.  They are facing a
>  > number of different regulatory issues, combined with lack of
>  > specifications from some vendors.  I don't think that the developers who
>  > actually have specs are complaining about anything right now.
>
> OK, one last reply before I give up on this thread...
>
> Sure, Ralink drivers will get upstream eventually.  But by the time
> the drivers get merged, Ralink will have stopped making the chips that
> it supports (or so I read, http://www.linuxemporium.co.uk/products/wireless/)!
> I don't think that taking a year or two to merge a driver is going to
> impress a vendor, especially since the reverse-engineered Broadcom
> wireless driver is probably going to go upstream at just about the
> same time.
>
> An uncharitable vendor might decide it's not worth publishing specs,
> since the Linux guys can reverse engineer the Windows driver just as
> fast anyway.

I'm sort of with Roland on this, the timelines aren't usually worth it
for a company to bother especially with complicated hardware, the time
taken to do a community graphics driver for any GPU where specs have
been available approaches infinity, unless the vendor actually does
the driver or pays someone to do the driver the hope of a community
supported driver reaching maturity while the product is still
available is slim.... for anyone desparate to start writing device
drivers, XGI have recently dropped a load of specs for their cards,
I'm not seeing anyone other than the usual GPU ppl step up an do
anything and as I said the time it takes a single volunteer to write a
GPU driver is a lot longer than the card...

Dave.
