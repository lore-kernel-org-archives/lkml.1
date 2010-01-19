Return-Path: <linux-kernel-owner+w=401wt.eu-S1756096Ab0ASJml@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756096Ab0ASJml (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 04:42:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756080Ab0ASJmj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 04:42:39 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:34500
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755805Ab0ASJmh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 04:42:37 -0500
Date: Tue, 19 Jan 2010 01:42:47 -0800 (PST)
Message-Id: <20100119.014247.243968259.davem@davemloft.net>
To: bzolnier@gmail.com
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 42/64] via82cxxx: workaround h/w bugs
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100118172000.14623.73749.sendpatchset@localhost>
References: <20100118171349.14623.90030.sendpatchset@localhost>
	<20100118172000.14623.73749.sendpatchset@localhost>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Date: Mon, 18 Jan 2010 18:20:00 +0100

> From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> Subject: [PATCH] via82cxxx: workaround h/w bugs
> 
> Add custom struct ide_tp_ops instance to fix the internal bug of some VIA
> chipsets which will reset the device register after changing the nIEN bit
> in the device control register.
> 
> Based on commit bfce5e0 for pata_via host driver.
> 
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

Applied.
