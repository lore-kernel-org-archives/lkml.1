Return-Path: <linux-kernel-owner+w=401wt.eu-S1757481AbYBWGkB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757481AbYBWGkB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 01:40:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751345AbYBWGjv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 01:39:51 -0500
Received: from smtp02.mtu.ru ([62.5.255.49]:65287 "EHLO smtp02.mtu.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751010AbYBWGju (ORCPT <rfc822; linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 01:39:50 -0500
From: Andrey Borzenkov <arvidjaar@mail.ru>
Subject: Re: 2.6.25-rc2 + smartd = hang
To: Jeff Garzik <jeff@garzik.org>, aeriksson@fastmail.fm,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Date: Sat, 23 Feb 2008 09:39:46 +0300
References: <20080222165122.8D2BB93C12F@tippex.mynet.homeunix.org> <47BF0DCD.4060400@garzik.org> <20080222185645.9DD9C93C12F@tippex.mynet.homeunix.org> <47BF3DE3.4000100@rtr.ca> <20080222213932.3403F93C12F@tippex.mynet.homeunix.org> <47BF45E4.4020006@garzik.org>
User-Agent: KNode/0.10.9
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
Message-Id: <20080223063943.4EF77364D5@smtp02.mtu.ru>
X-DCC-STREAM-Metrics: smtp02.mtu.ru 10002; Body=0 Fuz1=0 Fuz2=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik wrote:

>> If this is the prefered driver these days, maybe it shouldn't be marked
>> experimental in the menu anymore?
> 
> It's not marked experimental.
>

the comment on the very top of drivers/ata says:

tristate "Serial ATA (prod) and Parallel ATA (experimental) drivers"

this is a bit confusing

