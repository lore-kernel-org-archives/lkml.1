Return-Path: <linux-kernel-owner+w=401wt.eu-S1756729AbYLaR52@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756729AbYLaR52 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2008 12:57:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756062AbYLaR5U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Dec 2008 12:57:20 -0500
Received: from server.drzeus.cx ([85.8.24.28]:48952 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755889AbYLaR5T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2008 12:57:19 -0500
Date: Wed, 31 Dec 2008 18:57:14 +0100
From: Pierre Ossman <drzeus-mmc@drzeus.cx>
To: Vernon Sauder <vernoninhand@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [pxamci] fix dma_unmap_sg length
Message-ID: <20081231185714.42ca4063@mjolnir.drzeus.cx>
In-Reply-To: <20081229192128.18a17619@vsauder-lx.localdomain>
References: <20081229192128.18a17619@vsauder-lx.localdomain>
X-Mailer: Claws Mail 3.6.0 (GTK+ 2.14.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Dec 2008 19:21:28 -0500
Vernon Sauder <vernoninhand@gmail.com> wrote:

> dma_unmap_sg should be given the same length as dma_map_sg, not the
> value returned from dma_map_sg
> 
> Signed-off-by: Vernon Sauder <vsauder@inhand.com>
> ---

Quite right. Queued.

Thanks
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  rdesktop, core developer          http://www.rdesktop.org

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.
