Return-Path: <linux-kernel-owner+w=401wt.eu-S1758506AbXFVRPn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758506AbXFVRPn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 13:15:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754420AbXFVRPX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 13:15:23 -0400
Received: from mx0.towertech.it ([213.215.222.73]:47012 "HELO mx0.towertech.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753784AbXFVRPW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 13:15:22 -0400
Date: Fri, 22 Jun 2007 19:14:30 +0200
From: Alessandro Zummo <alessandro.zummo@towertech.it>
To: rtc-linux@googlegroups.com
Cc: anemo@mba.ocn.ne.jp, linux-kernel@vger.kernel.org, ab@mycable.de,
       mgreer@mvista.com, khali@linux-fr.org, david-b@pacbell.net,
       akpm@linux-foundation.org
Subject: Re: [rtc-linux] [PATCH 1/2] rtc: add rtc-m41t80 driver (take 2)
Message-ID: <20070622191430.7283ed57@inspiron>
In-Reply-To: <20070622.221320.25914626.anemo@mba.ocn.ne.jp>
References: <20070622.221320.25914626.anemo@mba.ocn.ne.jp>
Organization: Tower Technologies
X-Mailer: Sylpheed
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Jun 2007 22:13:20 +0900 (JST)
Atsushi Nemoto <anemo@mba.ocn.ne.jp> wrote:

> This is a new-style i2c driver for ST M41T80 series RTC chip, derived
> from works by Alexander Bigga <ab@mycable.de> who wrote the original
> rtc-m41txx.c based on drivers/i2c/chips/m41t00.c driver.
> 
> This driver supports M41T8[0-4] and M41ST8[457].  The old m41t00
> driver supports M41T00, M41T81 and M41T85(M41ST85).  While the M41T00
> chip is now supported by rtc-ds1307 driver, this driver does not
> include support for the chip.
> 
> Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
> Signed-off-by: Alexander Bigga <ab@mycable.de>
> Acked-by: Mark A. Greer <mgreer@mvista.com>

 Acked-by: Alessandro Zummo <a.zummo@towertech.it>

-- 

 Best regards,

 Alessandro Zummo,
  Tower Technologies - Torino, Italy

  http://www.towertech.it

