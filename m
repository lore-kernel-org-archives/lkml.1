Return-Path: <linux-kernel-owner+w=401wt.eu-S1763739AbXGPWaq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763739AbXGPWaq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 18:30:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760836AbXGPW3w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 18:29:52 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:37270 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756174AbXGPW3v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 18:29:51 -0400
Message-ID: <469BF15C.90906@garzik.org>
Date: Mon, 16 Jul 2007 18:29:48 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: Adrian Bunk <bunk@stusta.de>
CC: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       John Donoghue <john.donoghue@ieee.org>
Subject: Re: [2.6 patch] EP93XX_ETH must select MII
References: <20070713001208.GX3492@stusta.de>
In-Reply-To: <20070713001208.GX3492@stusta.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> From: John Donoghue <john.donoghue@ieee.org>
> 
> CONFIG_EP93XX_ETH=y, CONFIG_MII=n results in an obvious link error.
> 
> Signed-off-by: Adrian Bunk <bunk@stusta.de>

applied


