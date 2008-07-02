Return-Path: <linux-kernel-owner+w=401wt.eu-S1759538AbYGBMs4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759538AbYGBMs4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 08:48:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751832AbYGBMsq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 08:48:46 -0400
Received: from smtpeu1.atmel.com ([195.65.72.27]:64244 "EHLO bagnes.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751451AbYGBMsp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 08:48:45 -0400
Date: Wed, 2 Jul 2008 14:48:36 +0200
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: Pierre Ossman <drzeus-list@drzeus.cx>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5] Atmel MCI: Driver for Atmel on-chip MMC controllers
Message-ID: <20080702144836.0adcee65@hskinnemo-gx745.norway.atmel.com>
In-Reply-To: <1214843703-13199-1-git-send-email-haavard.skinnemoen@atmel.com>
References: <1214843703-13199-1-git-send-email-haavard.skinnemoen@atmel.com>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 02 Jul 2008 12:48:41.0751 (UTC) FILETIME=[F4C3B270:01C8DC41]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Haavard Skinnemoen <haavard.skinnemoen@atmel.com> wrote:
> Here's a simpler version of the driver with the DMA and debugfs bits
> removed, so you can apply it separately if you want. I'll hopefully
> have patches to add both back in by tomorrow.

Argh...I'm seeing data corruption issues with DMA enabled. I'm not sure
if I'll be able to figure it out before I leave for vacation next
week...and I have other stuff to do as well.

So I suggest you take the PIO-only driver and the debugfs stuff if it
looks ok to you. I'm sure I'll be able to sort out the DMA issues after
I get back in three weeks from today.

Haavard
