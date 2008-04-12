Return-Path: <linux-kernel-owner+w=401wt.eu-S1758296AbYDLSzz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758296AbYDLSzz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Apr 2008 14:55:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754847AbYDLSzo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Apr 2008 14:55:44 -0400
Received: from h155.mvista.com ([63.81.120.155]:45184 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755970AbYDLSzn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Apr 2008 14:55:43 -0400
Message-ID: <48010584.3020406@ru.mvista.com>
Date: Sat, 12 Apr 2008 22:55:00 +0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/5] ide: remove ->dma_vendor{1,3} fields from ide_hwif_t
References: <200804122105.09585.bzolnier@gmail.com>
In-Reply-To: <200804122105.09585.bzolnier@gmail.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bartlomiej Zolnierkiewicz wrote:

> * Use 'hwif->dma_base + {1,3}' instead of hwif->dma_vendor{1,3} in
>   pdc202xx_new host driver.

> * Remove no longer needed ->dma_vendor{1,3} fields from ide_hwif_t.

> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

Acked-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>

MBR, Sergei

