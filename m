Return-Path: <linux-kernel-owner+w=401wt.eu-S1755715AbZCPSsZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755715AbZCPSsZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 14:48:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752135AbZCPSsR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 14:48:17 -0400
Received: from 82-117-125-11.tcdsl.calypso.net ([82.117.125.11]:56173 "EHLO
	smtp.ossman.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752087AbZCPSsQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 14:48:16 -0400
Date: Mon, 16 Mar 2009 19:48:12 +0100
From: Pierre Ossman <drzeus-mmc@drzeus.cx>
To: Alexander Beregalov <a.beregalov@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] MMC: tmio_mmc.h: fix build problem
Message-ID: <20090316194812.1b81797b@mjolnir.ossman.eu>
In-Reply-To: <20090314093747.GA4995@orion>
References: <20090314093747.GA4995@orion>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.15.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 14 Mar 2009 12:37:47 +0300
Alexander Beregalov <a.beregalov@gmail.com> wrote:

> drivers/mmc/host/tmio_mmc.h: In function 'tmio_mmc_kmap_atomic':
> drivers/mmc/host/tmio_mmc.h:147: error: implicit declaration of function 'kmap_atomic'
> drivers/mmc/host/tmio_mmc.h:147: error: 'KM_BIO_SRC_IRQ' undeclared (first use in this function)
> drivers/mmc/host/tmio_mmc.h: In function 'tmio_mmc_kunmap_atomic':
> drivers/mmc/host/tmio_mmc.h:153: error: implicit declaration of function 'kunmap_atomic'
> drivers/mmc/host/tmio_mmc.h:153: error: 'KM_BIO_SRC_IRQ' undeclared (first use in this function)
> 
> Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>
> ---

Applied, thanks.

-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  rdesktop, core developer          http://www.rdesktop.org

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.
