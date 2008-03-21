Return-Path: <linux-kernel-owner+w=401wt.eu-S1757567AbYCUS2o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757567AbYCUS2o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 14:28:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754155AbYCUS2f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 14:28:35 -0400
Received: from ns2.mvista.com ([63.81.120.155]:4359 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753668AbYCUS2e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 14:28:34 -0400
Message-ID: <47E3FEA2.9080700@ru.mvista.com>
Date: Fri, 21 Mar 2008 21:29:54 +0300
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       Anton Vorontsov <avorontsov@ru.mvista.com>
Subject: Re: [PATCH 6/7] palm_bk3710: use ->init_dma method
References: <200803091632.50199.bzolnier@gmail.com>
In-Reply-To: <200803091632.50199.bzolnier@gmail.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bartlomiej Zolnierkiewicz wrote:

> * Move DMA setup to palm_bk3710_init_dma().

> * Convert the driver to use ->init_dma method.

> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

Acked-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>

MBR, Sergei
