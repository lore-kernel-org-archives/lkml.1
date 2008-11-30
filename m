Return-Path: <linux-kernel-owner+w=401wt.eu-S1756268AbYK3UHG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756268AbYK3UHG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2008 15:07:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752660AbYK3UGw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Nov 2008 15:06:52 -0500
Received: from server.drzeus.cx ([85.8.24.28]:56876 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752557AbYK3UGv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2008 15:06:51 -0500
Date: Sun, 30 Nov 2008 21:06:48 +0100
From: Pierre Ossman <drzeus-mmc@drzeus.cx>
To: avorontsov@ru.mvista.com
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       David Brownell <dbrownell@users.sourceforge.net>,
       Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH v2] mmc: Add mmc_vddrange_to_ocrmask() helper function
Message-ID: <20081130210648.77b8843a@mjolnir.drzeus.cx>
In-Reply-To: <20081126195417.GA26264@oksana.dev.rtsoft.ru>
References: <20081030195546.GA30645@oksana.dev.rtsoft.ru>
	<20081030195632.GB13640@oksana.dev.rtsoft.ru>
	<20081108215537.12cdf5f6@mjolnir.drzeus.cx>
	<20081126195417.GA26264@oksana.dev.rtsoft.ru>
X-Mailer: Claws Mail 3.6.0 (GTK+ 2.14.4; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Nov 2008 22:54:17 +0300
Anton Vorontsov <avorontsov@ru.mvista.com> wrote:

> This function sets the OCR mask bits according to provided voltage
> ranges. Will be used by the mmc_spi OpenFirmware bindings.
> 
> Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
> ---
> 
> Hi Pierre,
> 
> Sorry for the delay.
> 

This looks perfect. Just tell me when you want me to queue it up.

Rgds
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  rdesktop, core developer          http://www.rdesktop.org

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.
