Return-Path: <linux-kernel-owner+w=401wt.eu-S1752761Ab0AKIhf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752761Ab0AKIhf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 03:37:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752712Ab0AKIhe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 03:37:34 -0500
Received: from bamako.nerim.net ([62.4.17.28]:54979 "EHLO bamako.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752273Ab0AKIhc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 03:37:32 -0500
Date: Mon, 11 Jan 2010 09:37:29 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Steven King <sfking@fdwdc.com>
Cc: gerg@snapgear.com, ben-linux@fluff.org, linux-i2c@vger.kernel.org,
       linux-kernel@vger.kernel.org, uclinux-dev@uclinux.org
Subject: Re: [PATCH] m68knommu: driver for Freescale Coldfire I2C
 controller.
Message-ID: <20100111093729.63455a90@hyperion.delvare>
In-Reply-To: <201001101600.41932.sfking@fdwdc.com>
References: <201001101600.41932.sfking@fdwdc.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 10 Jan 2010 16:00:41 -0800, Steven King wrote:
> Add support for the I2C controller used on Freescale/Motorola Coldfire MCUs. 
> 
> Signed-off-by: Steven King <sfking@fdwdc.com>
> 
>  drivers/i2c/busses/Kconfig   |   11 +
>  drivers/i2c/busses/Makefile  |    1 +
>  drivers/i2c/busses/i2c-mcf.c |  463 ++++++++++++++++++++++++++++++++++++++++++

Please come up with a longer name. i2c-coldfire, for example.

-- 
Jean Delvare
