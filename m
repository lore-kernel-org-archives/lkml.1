Return-Path: <linux-kernel-owner+w=401wt.eu-S1754118AbYIBVi3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754118AbYIBVi3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2008 17:38:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752093AbYIBViT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Sep 2008 17:38:19 -0400
Received: from h155.mvista.com ([63.81.120.155]:16215 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751646AbYIBViS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2008 17:38:18 -0400
Message-ID: <48BDB244.5090106@ru.mvista.com>
Date: Wed, 03 Sep 2008 01:38:12 +0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/8] ide: __ide_dma_end() -> ide_dma_end()
References: <20080902194711.14564.63625.sendpatchset@localhost.localdomain>
In-Reply-To: <20080902194711.14564.63625.sendpatchset@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Bartlomiej Zolnierkiewicz wrote:

> While at it:
> - use EXPORT_SYMBOL_GPL() to match the rest of SFF DMA functions
>
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

Acked-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>

MBR, Sergei


