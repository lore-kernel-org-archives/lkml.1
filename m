Return-Path: <linux-kernel-owner+w=401wt.eu-S1758242AbYF1NtQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758242AbYF1NtQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2008 09:49:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754603AbYF1Ns7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jun 2008 09:48:59 -0400
Received: from smtpeu1.atmel.com ([195.65.72.27]:49755 "EHLO bagnes.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753281AbYF1Ns6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2008 09:48:58 -0400
Date: Sat, 28 Jun 2008 15:49:07 +0200
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: Pierre Ossman <drzeus-mmc@drzeus.cx>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] mmc: Export internal host state through debugfs
Message-ID: <20080628154907.27de26a9@hskinnemo-gx745.norway.atmel.com>
In-Reply-To: <20080628154015.423daf51@mjolnir.drzeus.cx>
References: <1214478589-21291-1-git-send-email-haavard.skinnemoen@atmel.com>
	<20080628152856.3ba1c2ff@mjolnir.drzeus.cx>
	<20080628153704.36eda3e6@hskinnemo-gx745.norway.atmel.com>
	<20080628154015.423daf51@mjolnir.drzeus.cx>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 28 Jun 2008 13:48:55.0596 (UTC) FILETIME=[B521AEC0:01C8D925]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pierre Ossman <drzeus-mmc@drzeus.cx> wrote:
> Fewer lines though. Those dummy function stick out like a sore thumb.
> It's a decent trade-off when you have multiple callers, but here we have
> just the one.

Ok, I'll change it.

Haavard
