Return-Path: <linux-kernel-owner+w=401wt.eu-S1753346AbYKGIIj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753346AbYKGIIj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 03:08:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751281AbYKGII2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 03:08:28 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:57364 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751124AbYKGII1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 03:08:27 -0500
Message-ID: <4913F778.7000206@garzik.org>
Date: Fri, 07 Nov 2008 03:08:24 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [git patches] net driver updates for 2.6.29
References: <20081106065059.GA19202@havoc.gtf.org> <20081106.221330.181959128.davem@davemloft.net>
In-Reply-To: <20081106.221330.181959128.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote:
> From: Jeff Garzik <jeff@garzik.org>
> Date: Thu, 6 Nov 2008 01:50:59 -0500
> 
>> Please pull from 'davem-next' branch of
>> master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/netdev-2.6.git davem-next
>>
>> to receive the following updates:
> 
> drivers/net/usb/usbnet.c: In function 'usbnet_suspend':
> drivers/net/usb/usbnet.c:1357: error: 'struct usb_device' has no member named 'auto_pm'
> 
> Please fix this up and send me another pull request.

hmmm, builds for me on x86 and x86-64.

<looks>  are you building with CONFIG_PM disabled, perhaps?  I'll try 
that build next...

	Jeff




