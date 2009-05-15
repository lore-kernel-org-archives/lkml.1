Return-Path: <linux-kernel-owner+w=401wt.eu-S1762446AbZEONKF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762446AbZEONKF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 09:10:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761808AbZEONJv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 09:09:51 -0400
Received: from smtp.nokia.com ([192.100.105.134]:61870 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756385AbZEONJv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 09:09:51 -0400
Subject: Re: [resending-2] [PATCH] [MTD] [NAND] Add OMAP2 / OMAP3 NAND
 driver
From: Artem Bityutskiy <dedekind@infradead.org>
Reply-To: dedekind@infradead.org
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mtd@lists.infradead.org,
       linux-kernel@vger.kernel.org, vimal singh <vimalsingh@ti.com>
In-Reply-To: <46851.192.168.10.89.1241083986.squirrel@dbdmail.itg.ti.com>
References: <61255.192.168.10.89.1240984646.squirrel@dbdmail.itg.ti.com>
	 <46851.192.168.10.89.1241083986.squirrel@dbdmail.itg.ti.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 15 May 2009 16:08:39 +0300
Message-Id: <1242392919.27996.238.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 15 May 2009 13:08:41.0184 (UTC) FILETIME=[44A16600:01C9D55E]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-04-30 at 15:03 +0530, vimal singh wrote:
> This driver is present in the OMAP tree, now pushing it to MTD.
> 
> Original author(s):
>        Jian Zhang <jzhang@ti.com>
> 
> Signed-off-by: Vimal Singh <vimalsingh@ti.com>
> ---
>  drivers/mtd/nand/Kconfig  |    6
>  drivers/mtd/nand/Makefile |    1
>  drivers/mtd/nand/omap2.c  |  776 ++++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 783 insertions(+)

Hi Thomas,

would you please find a little time and Ack/Nack this
please?

-- 
Best regards,
Artem Bityutskiy (Битюцкий Артём)

