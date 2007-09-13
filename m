Return-Path: <linux-kernel-owner+w=401wt.eu-S1759307AbXIMENO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759307AbXIMENO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 00:13:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751446AbXIMEM5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 00:12:57 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:46649 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751411AbXIMEM4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 00:12:56 -0400
Message-ID: <46E8B8C4.5010203@garzik.org>
Date: Thu, 13 Sep 2007 00:12:52 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Hans-J=FCrgen_Koch?= <hjk@linutronix.de>
CC: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       afleming@freescale.com
Subject: Re: [PATCH] Fix a lock problem in generic phy code
References: <200708311430.09590.hjk@linutronix.de>
In-Reply-To: <200708311430.09590.hjk@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hans-Jürgen Koch wrote:
> Lock debugging finds a problem in phy.c and phy_device.c,
> this patch fixes it. Tested on an AT91SAM9263-EK board, 
> kernel 2.6.23-rc4.
> 
> Signed-off-by: Hans J. Koch <hjk@linutronix.de>

applied


