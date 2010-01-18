Return-Path: <linux-kernel-owner+w=401wt.eu-S1752343Ab0AROMJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752343Ab0AROMJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 09:12:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751395Ab0AROMI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 09:12:08 -0500
Received: from dan.rpsys.net ([93.97.175.187]:61860 "EHLO dan.rpsys.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752170Ab0AROMH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 09:12:07 -0500
Subject: Re: [PATCH] backlight: lcd: Add Epson L4F00242T03 LCD driver.
From: Richard Purdie <rpurdie@rpsys.net>
To: Alberto Panizzo <maramaopercheseimorto@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Eric Miao <eric.y.miao@gmail.com>
In-Reply-To: <1261150931.3356.54.camel@climbing-alby>
References: <1261150931.3356.54.camel@climbing-alby>
Content-Type: text/plain
Date: Mon, 18 Jan 2010 14:12:13 +0000
Message-Id: <1263823933.26227.106.camel@dax.rpnet.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-12-18 at 16:42 +0100, Alberto Panizzo wrote:
> The Epson LCD L4F00242T03 is mounted on the Freescale i.MX31 PDK
> board.
> Based upon Marek Vasut work in l4f00242t03.c, this driver provide
> basilar init and power on/off functionality for this device.
> Those functionality are accessible also through the /sys/class/lcd
> interface.
> Unfortunately Datasheet for this device are not available. 
> All the control sequences sent to the display were copied from the
> peer freescale driver that leave in the i.MX31 Linux BSP.
> 
> The driver is tested to work as a module and build-in too.
> As in the i.MX31PDK board the core and io suppliers are voltage
> regulators, that functionality is embedded here, but not strict.

I queued this patch in the backlight tree, thanks.

Richard


-- 
Richard Purdie
Intel Open Source Technology Centre

