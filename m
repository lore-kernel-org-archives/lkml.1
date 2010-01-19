Return-Path: <linux-kernel-owner+w=401wt.eu-S1756552Ab0ASJzY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756552Ab0ASJzY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 04:55:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756303Ab0ASJzA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 04:55:00 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:50270
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756368Ab0ASJyb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 04:54:31 -0500
Date: Tue, 19 Jan 2010 01:54:40 -0800 (PST)
Message-Id: <20100119.015440.239402809.davem@davemloft.net>
To: bzolnier@gmail.com
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 63/64] via82cxxx: use ->pio_mode value to determine
 pair device speed
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100118172230.14623.55986.sendpatchset@localhost>
References: <20100118171349.14623.90030.sendpatchset@localhost>
	<20100118172230.14623.55986.sendpatchset@localhost>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Date: Mon, 18 Jan 2010 18:22:30 +0100

> From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> Subject: [PATCH] via82cxxx: use ->pio_mode value to determine pair device speed
> 
> Use the current PIO mode value instead of the current transfer speed
> of the pair device on the port to determine PIO commmand timings used
> for both devices on the port.
> 
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

Applied.
