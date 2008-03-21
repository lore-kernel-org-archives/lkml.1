Return-Path: <linux-kernel-owner+w=401wt.eu-S1757901AbYCUSZF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757901AbYCUSZF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 14:25:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754155AbYCUSYx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 14:24:53 -0400
Received: from ns2.mvista.com ([63.81.120.155]:4340 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753106AbYCUSYw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 14:24:52 -0400
Message-ID: <47E3FDC3.7080208@ru.mvista.com>
Date: Fri, 21 Mar 2008 21:26:11 +0300
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 7/7] au1xxx-ide: use ->init_dma method
References: <200803091633.39456.bzolnier@gmail.com>
In-Reply-To: <200803091633.39456.bzolnier@gmail.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bartlomiej Zolnierkiewicz wrote:

> * Pass 'ide_hwif_t *hwif' instead of '_auide_hwif *auide' to
>   auide_ddma_init().

> * Add 'const struct ide_port_info *d' argument to auide_ddma_init().

> * Convert the driver to use ->init_dma method.

> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

Acked-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>

MBR, Sergei
