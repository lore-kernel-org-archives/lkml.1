Return-Path: <linux-kernel-owner+w=401wt.eu-S1756168Ab0ASJnL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756168Ab0ASJnL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 04:43:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756108Ab0ASJnA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 04:43:00 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:34512
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756055Ab0ASJm6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 04:42:58 -0500
Date: Tue, 19 Jan 2010 01:43:08 -0800 (PST)
Message-Id: <20100119.014308.262862368.davem@davemloft.net>
To: bzolnier@gmail.com
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 45/64] via82cxxx: fix UDMA settings programming
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100118172021.14623.2326.sendpatchset@localhost>
References: <20100118171349.14623.90030.sendpatchset@localhost>
	<20100118172021.14623.2326.sendpatchset@localhost>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Date: Mon, 18 Jan 2010 18:20:21 +0100

> From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> Subject: [PATCH] via82cxxx: fix UDMA settings programming
> 
> * preserve 80-wire cable detection bit
> * don't clear UDMA settings when programming PIO/MWDMA modes
> 
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

Applied.
