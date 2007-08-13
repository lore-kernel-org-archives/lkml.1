Return-Path: <linux-kernel-owner+w=401wt.eu-S974361AbXHMSGp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S974361AbXHMSGp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 14:06:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S974175AbXHMRx0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 13:53:26 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:3331 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S974171AbXHMRxV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 13:53:21 -0400
Subject: Re: [PATCH] [206/2many] MAINTAINERS - GENERIC GPIO I2C DRIVER
From: Joe Perches <joe@perches.com>
To: Haavard Skinnemoen <hskinnemoen@atmel.com>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, David Brownell <david-b@pacbell.net>
In-Reply-To: <20070813123924.25d422ac@dhcp-255-175.norway.atmel.com>
References: <46bff9fc.i+o8WMM7bF8WiNL9%joe@perches.com>
	 <20070813123924.25d422ac@dhcp-255-175.norway.atmel.com>
Content-Type: text/plain
Date: Mon, 13 Aug 2007 10:52:33 -0700
Message-Id: <1187027553.10249.179.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2-2.1mdv2007.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-08-13 at 12:39 +0200, Haavard Skinnemoen wrote:
> Patches for Documentation/gpio.txt should probably be sent to
> linux-arch and David Brownell, who is the one who wrote it.

Thanks.

David, think it's worth tracking gpio.txt somewhere at all?

GENERIC GPIO I2C DRIVER
P:	Haavard Skinnemoen
M:	hskinnemoen@atmel.com
S:	Supported
F:	drivers/i2c/busses/i2c-gpio.c
F:	include/linux/i2c-gpio.h


