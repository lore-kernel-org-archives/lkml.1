Return-Path: <linux-kernel-owner+w=401wt.eu-S1754373AbXGBMZ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754373AbXGBMZ0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2007 08:25:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754015AbXGBMZJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jul 2007 08:25:09 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:50909 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753326AbXGBMZH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2007 08:25:07 -0400
Message-ID: <4688EE9E.2080005@garzik.org>
Date: Mon, 02 Jul 2007 08:25:02 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: Maik Hampel <m.hampel@gmx.de>
CC: Brice Goglin <brice@myri.com>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] myri10ge: SET_NETDEV_DEV()
References: <1183043246.2659.19.camel@c64>
In-Reply-To: <1183043246.2659.19.camel@c64>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Maik Hampel wrote:
> SET_NETDEV_DEV() in myri10ge to create the "/sys/class/net/<if>/device"
> symlink.
> 
> Signed-off-by: Maik Hampel <m.hampel@gmx.de>

applied


