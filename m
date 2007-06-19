Return-Path: <linux-kernel-owner+w=401wt.eu-S1764738AbXFSTu0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764738AbXFSTu0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 15:50:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758621AbXFSTuR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 15:50:17 -0400
Received: from fw1-az.mvista.com ([65.200.49.156]:8865 "EHLO
	zipcode.az.mvista.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752109AbXFSTuQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 15:50:16 -0400
X-Greylist: delayed 1333 seconds by postgrey-1.27 at vger.kernel.org; Tue, 19 Jun 2007 15:50:16 EDT
Date: Tue, 19 Jun 2007 12:25:05 -0700
From: "Mark A. Greer" <mgreer@mvista.com>
To: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Cc: a.zummo@towertech.it, linux-kernel@vger.kernel.org,
       rtc-linux@googlegroups.com, ab@mycable.de, mgreer@mvista.com,
       khali@linux-fr.org, david-b@pacbell.net
Subject: Re: [PATCH 1/2] rtc: add rtc-m41txx driver
Message-ID: <20070619192505.GA363@mag.az.mvista.com>
References: <20070620.005926.52130307.anemo@mba.ocn.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070620.005926.52130307.anemo@mba.ocn.ne.jp>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 20, 2007 at 12:59:26AM +0900, Atsushi Nemoto wrote:
> This is a new-style i2c driver for ST M41TXX RTC chip, derived from
> works by Alexander Bigga <ab@mycable.de> who wrote the original
> rtc-m41txx.c based on drivers/i2c/chips/m41t00.c driver.
> 
> This driver supports M41T80, M41T81 and M41ST85.  The old m41t00
> driver supports M41T00, M41T81 and M41T85(M41ST85).  While the M41T00
> chip is now supported by rtc-ds1307 driver, this driver does not
> include support for the chip.
> 
> Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
> Signed-off-by: Alexander Bigga <ab@mycable.de>

Other than addressing David's question about alarm support,

Acked-by: Mark A. Greer <mgreer@mvista.com>
