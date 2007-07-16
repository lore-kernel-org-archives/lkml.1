Return-Path: <linux-kernel-owner+w=401wt.eu-S1764740AbXGPL7W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764740AbXGPL7W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 07:59:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758013AbXGPL6y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 07:58:54 -0400
Received: from emh06.mail.saunalahti.fi ([62.142.5.116]:40538 "EHLO
	emh06.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757180AbXGPL6x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 07:58:53 -0400
Date: Mon, 16 Jul 2007 14:58:38 +0300 (EEST)
From: Kai Makisara <Kai.Makisara@kolumbus.fi>
X-X-Sender: makisara@kai.makisara.local
To: Tejun Heo <htejun@gmail.com>
cc: Bruce Allen <ballen@gravity.phys.uwm.edu>, Mark Lord <liml@rtr.ca>,
       David Greaves <david@dgreaves.com>, Douglas Gilbert <dougg@torque.net>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Jeff Garzik <jeff@garzik.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jan Dvorak <fermentol@gmail.com>,
       Klaus Fuerstberger <kfuerstberger@arcor.de>,
       Bruce Allen <bruce.allen@aei.mpg.de>, Robert Hancock <hancockr@shaw.ca>
Subject: Re: SMART problems in 2.6.22
In-Reply-To: <469B54DE.5090703@gmail.com>
Message-ID: <Pine.LNX.4.64.0707161453230.5065@kai.makisara.local>
References: <Pine.LNX.4.63.0707081910050.21572@trinity.phys.uwm.edu>
 <Pine.LNX.4.64.0707092341280.4779@kai.makisara.local>
 <Pine.LNX.4.64.0707161327470.4941@kai.makisara.local> <469B54DE.5090703@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Antivirus: VAMS
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Jul 2007, Tejun Heo wrote:

> Please try the patch in the following message.
> 
> http://article.gmane.org/gmane.linux.ide/20799/raw
> 
This solves the 'smartctl -H' problem both of my systems (one with Nvidia 
CK804 and one with MCP51).

Tested-by: Kai Makisara <Kai.Makisara@kolumbus.fi>

Thanks for pointing out the patch.

-- 
Kai
