Return-Path: <linux-kernel-owner+w=401wt.eu-S1756056Ab0ASJmf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756056Ab0ASJmf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 04:42:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755962Ab0ASJma
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 04:42:30 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:34496
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756037Ab0ASJm3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 04:42:29 -0500
Date: Tue, 19 Jan 2010 01:42:39 -0800 (PST)
Message-Id: <20100119.014239.114818350.davem@davemloft.net>
To: bzolnier@gmail.com
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 41/64] via82cxxx: fix SATA cable detection
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100118171953.14623.7914.sendpatchset@localhost>
References: <20100118171349.14623.90030.sendpatchset@localhost>
	<20100118171953.14623.7914.sendpatchset@localhost>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Date: Mon, 18 Jan 2010 18:19:53 +0100

> From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> Subject: [PATCH] via82cxxx: fix SATA cable detection
> 
> Add VIA_SATA_PATA flag for cx700, vx800 and vx855 chipsets
> (the first port is SATA).
> 
> Based on commits 7585eb1, bfce5e0 and e4d866c for pata_via
> host driver.
> 
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

Applied.
