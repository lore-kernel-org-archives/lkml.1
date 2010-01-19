Return-Path: <linux-kernel-owner+w=401wt.eu-S1756154Ab0ASJnt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756154Ab0ASJnt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 04:43:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756185Ab0ASJnh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 04:43:37 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:34516
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756055Ab0ASJnF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 04:43:05 -0500
Date: Tue, 19 Jan 2010 01:43:15 -0800 (PST)
Message-Id: <20100119.014315.179494177.davem@davemloft.net>
To: bzolnier@gmail.com
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 46/64] ide: add drive->pio_mode field
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100118172028.14623.55296.sendpatchset@localhost>
References: <20100118171349.14623.90030.sendpatchset@localhost>
	<20100118172028.14623.55296.sendpatchset@localhost>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Date: Mon, 18 Jan 2010 18:20:28 +0100

> From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> Subject: [PATCH] ide: add drive->pio_mode field
> 
> Add pio_mode field to ide_drive_t matching pio_mode field used in
> struct ata_device.
> 
> The validity of the field is restricted to ->set_pio_mode method
> only currently in IDE subsystem.
> 
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

Applied.
