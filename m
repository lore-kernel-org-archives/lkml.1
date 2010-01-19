Return-Path: <linux-kernel-owner+w=401wt.eu-S1755748Ab0ASJ3N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755748Ab0ASJ3N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 04:29:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755934Ab0ASJ0H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 04:26:07 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:46311
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755849Ab0ASJ0D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 04:26:03 -0500
Date: Tue, 19 Jan 2010 01:26:13 -0800 (PST)
Message-Id: <20100119.012613.189228887.davem@davemloft.net>
To: bzolnier@gmail.com
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 30/64] amd74xx: don't change UDMA settings when
 programming PIO timings
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100118171817.14623.7796.sendpatchset@localhost>
References: <20100118171349.14623.90030.sendpatchset@localhost>
	<20100118171817.14623.7796.sendpatchset@localhost>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Date: Mon, 18 Jan 2010 18:18:17 +0100

> From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> Subject: [PATCH] amd74xx: don't change UDMA settings when programming PIO timings
> 
> Based on libata pata_amd host driver.
> 
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

Applied.
