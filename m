Return-Path: <linux-kernel-owner+w=401wt.eu-S935487AbYEVK22@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935487AbYEVK22 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 06:28:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933348AbYEVK2C
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 06:28:02 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:60837 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764570AbYEVK2A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 06:28:00 -0400
Message-ID: <48354A88.7060905@garzik.org>
Date: Thu, 22 May 2008 06:27:20 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Krzysztof Halasa <khc@pm.waw.pl>
CC: alan@lxorguk.ukuu.org.uk, David Miller <davem@davemloft.net>,
       paulkf@microgate.com, jchapman@katalix.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] WAN: protect HDLC proto list while insmod/rmmod
References: <20080424.065555.30390704.davem@davemloft.net>	<m3ve27nfpx.fsf@maximus.localdomain>	<20080424214457.1d5a1655@the-village.bc.nu>	<20080512.033244.153113922.davem@davemloft.net>	<m3lk2djbq3.fsf@maximus.localdomain> <m3ve1agrek.fsf_-_@maximus.localdomain>
In-Reply-To: <m3ve1agrek.fsf_-_@maximus.localdomain>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.4 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Krzysztof Halasa wrote:
> WAN: protect protocol list in hdlc.c with RTNL.
>     
> Signed-off-by: Krzysztof Ha³asa <khc@pm.waw.pl>

applied


