Return-Path: <linux-kernel-owner+w=401wt.eu-S1754592AbYCIUQg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754592AbYCIUQg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2008 16:16:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752878AbYCIUQ2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Mar 2008 16:16:28 -0400
Received: from h155.mvista.com ([63.81.120.155]:36957 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752665AbYCIUQ1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2008 16:16:27 -0400
Message-ID: <47D445E6.7050304@ru.mvista.com>
Date: Sun, 09 Mar 2008 23:17:42 +0300
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/7] ide: export ide_allocate_dma_engine()
References: <200803082232.35296.bzolnier@gmail.com>
In-Reply-To: <200803082232.35296.bzolnier@gmail.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bartlomiej Zolnierkiewicz wrote:

> Export ide_allocate_dma_engine() and use it in trm290 host driver.

> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

Acked-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>

MBR, Sergei
