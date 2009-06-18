Return-Path: <linux-kernel-owner+w=401wt.eu-S1755083AbZFRFSR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755083AbZFRFSR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 01:18:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751954AbZFRFSF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 01:18:05 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:4754 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751948AbZFRFSE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 01:18:04 -0400
Subject: Re: [PATCH] mmc: Add new via-sdmmc host controller driver
From: Joe Perches <joe@perches.com>
To: Harald Welte <HaraldWelte@viatech.com>
Cc: Pierre Ossman <pierre@ossman.eu>,
       Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>,
       JosephChan@via.com.tw, Bruce Chang <BruceChang@via.com.tw>
In-Reply-To: <20090617182239.GG7692@prithivi.gnumonks.org>
References: <20090617182239.GG7692@prithivi.gnumonks.org>
Content-Type: text/plain
Date: Wed, 17 Jun 2009 22:17:36 -0700
Message-Id: <1245302256.29927.2.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-06-17 at 20:22 +0200, Harald Welte wrote:
> Signed-off-by: Harald Welte <HaraldWelte@viatech.com>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index b5cebdd..ec8ffb8 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -6175,6 +6175,14 @@ S:	Maintained
>  F:	Documentation/i2c/busses/i2c-viapro
>  F:	drivers/i2c/busses/i2c-viapro.c
>  
> +VIA SD/MMC CARD CONTROLLER DRIVER
> +P:	Joseph Chan
> +M:	JosephChan@via.com.tw
> +P:	Harald Welte
> +M:	HaraldWelte@viatech.com
> +S:	MAINTAINED
> +F:	drivers/mmc/host/via-sdmmc.c
> +
>  VIA UNICHROME(PRO)/CHROME9 FRAMEBUFFER DRIVER
>  P:	Joseph Chan
>  M:	JosephChan@via.com.tw

I suggest you use what every other entry uses
S:	Maintained


