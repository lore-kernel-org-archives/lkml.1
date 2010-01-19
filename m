Return-Path: <linux-kernel-owner+w=401wt.eu-S1756126Ab0ASJpq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756126Ab0ASJpq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 04:45:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755715Ab0ASJpn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 04:45:43 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:46198
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755694Ab0ASJpm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 04:45:42 -0500
Date: Tue, 19 Jan 2010 01:45:52 -0800 (PST)
Message-Id: <20100119.014552.133883369.davem@davemloft.net>
To: bzolnier@gmail.com
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 49/64] ide: change ->set_dma_mode method parameters
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100118172050.14623.98373.sendpatchset@localhost>
References: <20100118171349.14623.90030.sendpatchset@localhost>
	<20100118172050.14623.98373.sendpatchset@localhost>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Date: Mon, 18 Jan 2010 18:20:50 +0100

> From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> Subject: [PATCH] ide: change ->set_dma_mode method parameters
> 
> Change ->set_dma_mode method parameters to match ->set_dmamode method
> used in struct ata_port_operations.
> 
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

Applied.
