Return-Path: <linux-kernel-owner+w=401wt.eu-S1756638AbYKCW7n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756638AbYKCW7n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 17:59:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753969AbYKCW7d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 17:59:33 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:59361 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752314AbYKCW7c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 17:59:32 -0500
Message-ID: <490F824E.3070809@garzik.org>
Date: Mon, 03 Nov 2008 17:59:26 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Marcel Holtmann <marcel@holtmann.org>
CC: David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [git patches] net driver fixes for 2.6.28-rc
References: <20081103205121.GA6005@havoc.gtf.org> <B9DCBB9E-9DE3-4114-9FFC-7A7C0C3DA920@holtmann.org>
In-Reply-To: <B9DCBB9E-9DE3-4114-9FFC-7A7C0C3DA920@holtmann.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Marcel Holtmann wrote:
> Hi Jeff,
> 
>> Please pull from 'davem-fixes' branch of
>> master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/netdev-2.6.git 
>> davem-fixes
>>
>> to receive the following updates:
>>
>> drivers/net/Kconfig                |   18 +++++++++++++++---
>> drivers/net/fs_enet/fs_enet-main.c |    6 ++++--
>> drivers/net/mv643xx_eth.c          |    9 ++++++---
>> 3 files changed, 25 insertions(+), 8 deletions(-)
> 
> are you also queuing patches for drivers/net/usb/hso.c, because the 
> current state of that driver is fully broken. It oopses and shows up 
> with a WLAN RFKILL switch instead of WWAN. Also it has some weird 
> disconnect race with the TTY layer. Some patches have been posted, but 
> seems that nobody has picked them up so far.

Last patch sent me was sent on 9/16 by Denis Joseph Barrow; I replied 
and never received a response after that.

Patches welcome...

I don't see any hso patches on
http://patchwork.ozlabs.org/project/netdev/list/ nor in my inbox, so I'm 
guessing that no one sent me or netdev any hso patches.

	Jeff


