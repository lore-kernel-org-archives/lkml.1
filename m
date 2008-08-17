Return-Path: <linux-kernel-owner+w=401wt.eu-S1755467AbYHQSCw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755467AbYHQSCw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2008 14:02:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752491AbYHQSCo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Aug 2008 14:02:44 -0400
Received: from server.drzeus.cx ([85.8.24.28]:42555 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751155AbYHQSCo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2008 14:02:44 -0400
Date: Sun, 17 Aug 2008 20:02:39 +0200
From: Pierre Ossman <drzeus-mmc@drzeus.cx>
To: Huang Weiyi <weiyi.huang@gmail.com>
Cc: linux-kernel@vger.kernel.org, saschasommer@freenet.de
Subject: Re: [MMC] removed unused #include <version.h>
Message-ID: <20080817200239.668f5091@mjolnir.drzeus.cx>
In-Reply-To: <20080817070801.1622.WEIYI.HUANG@gmail.com>
References: <20080817070801.1622.WEIYI.HUANG@gmail.com>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.13.6; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 17 Aug 2008 07:51:10 +0800
Huang Weiyi <weiyi.huang@gmail.com> wrote:

> The drivers below do not use LINUX_VERSION_CODE nor KERNEL_VERSION.
>   drivers/mmc/host/sdricoh_cs.c
> 
> This patch removes the said #include <version.h>.
> 
> Signed-off-by: Huang Weiyi <weiyi.huang@gmail.com>
> 

This was a really trivial patch, so I've applied it. But you really
should cc the driver maintainer in the future.

-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  rdesktop, core developer          http://www.rdesktop.org

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.
