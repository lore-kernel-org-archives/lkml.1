Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757758Ab0BLUiZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 15:38:25 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:57816
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757683Ab0BLUiY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 15:38:24 -0500
Date: Fri, 12 Feb 2010 12:38:37 -0800 (PST)
Message-Id: <20100212.123837.56526847.davem@davemloft.net>
To: david-b@pacbell.net
Cc: joe@perches.com, gregkh@suse.de, linux-usb@vger.kernel.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       oliver@neukum.name, jacmet@sunsite.dk, steve.glendinning@smsc.com
Subject: Re: [PATCH] usbnet: convert dev(dbg|err|warn|info) macros to
 usbnet_(dbg|err|warn|info)
From: David Miller <davem@davemloft.net>
In-Reply-To: <201002092256.30175.david-b@pacbell.net>
References: <201002092153.22322.david-b@pacbell.net>
	<1265782578.20626.17.camel@Joe-Laptop.home>
	<201002092256.30175.david-b@pacbell.net>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Brownell <david-b@pacbell.net>
Date: Tue, 9 Feb 2010 22:56:29 -0800

> On Tuesday 09 February 2010, Joe Perches wrote:
> 
>> netdev_printk macros instead.
>> 
>> http://patchwork.ozlabs.org/patch/44955/
> 
> That'd make sense.  Had they existed way back when ...
> they could have been used instead of custom stuff.

Joe, this patch doesn't apply cleanly to net-next-2.6 so could
you respin whatever variant of this you want me to apply?

Thanks!
