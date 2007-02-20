Return-Path: <linux-kernel-owner+w=401wt.eu-S965026AbXBTPPe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965026AbXBTPPe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 10:15:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965028AbXBTPPe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 10:15:34 -0500
Received: from wr-out-0506.google.com ([64.233.184.230]:41615 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965026AbXBTPPb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 10:15:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ai1bkiyerJm1OZgvdbKJ2bCNhO6LBfg4oOZdTVJ93deksQB+EIAzIsCpn3Wr+3pBGiCZDty9v1v8CYDNL9MIEKCft+R2dJ7wSuqcbUN5TNqA/c9qfnnNPP8DDzRvNkLPSOTG5xirn+q2rjbtXFyUodXg0auPYcI7V1GSDmvcPss=
Message-ID: <d120d5000702200715u130ee6b2i4a415aea24aa695d@mail.gmail.com>
Date: Tue, 20 Feb 2007 10:15:26 -0500
From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: "Greg KH" <greg@kroah.com>
Subject: Re: Network: convert network devices to use struct device instead of class_device
Cc: "Stephen Hemminger" <shemminger@linux-foundation.org>,
       "Jeff Garzik" <jeff@garzik.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       netdev <netdev@vger.kernel.org>, "Kay Sievers" <kay.sievers@vrfy.org>
In-Reply-To: <20070209005601.GE30794@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200702080400.l1840lFd002314@hera.kernel.org>
	 <45CB1AE6.9020707@garzik.org> <20070208074130.29df585f@oldman>
	 <d120d5000702080929r7016de12k292add26a0a72291@mail.gmail.com>
	 <20070209005601.GE30794@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/8/07, Greg KH <greg@kroah.com> wrote:
>
> And it should also alow for proper power management functionality, using
> the changes that Linus put into the driver core about 8 months ago.
>
> Don't worry, I have input patches queued up next for you Dmitry :)
>

Greg,

Could you please forward me these patches for input core - I am going
to rearrange some code and don't want too many clashes so I'd like to
apply yours to my private three and work from there...

Thanks!

-- 
Dmitry
