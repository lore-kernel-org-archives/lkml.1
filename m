Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755526Ab0BJG6e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Feb 2010 01:58:34 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:56122 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750738Ab0BJG6d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Feb 2010 01:58:33 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH v2 -mm 14/14] add linux/pci-dma.h to linux/pci.h
Date: Wed, 10 Feb 2010 07:58:28 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31-14-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
References: <1265765687-14121-1-git-send-email-fujita.tomonori@lab.ntt.co.jp> <1265765687-14121-15-git-send-email-fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <1265765687-14121-15-git-send-email-fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201002100758.28185.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18sw9wTyICpqE2qaVumVrCn60jQsU9r5nkFOyj
 NTh3lcdvKt5RTm11q9Rs6SwRCkLvyz7ESS47tZeL0RXpk4o2OV
 1/WFl1E6t7UD5dKx7nsog==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 10 February 2010, FUJITA Tomonori wrote:
> All the architectures properly set NEED_DMA_MAP_STATE now so we can
> safely add linux/pci-dma.h to linux/pci.h and remove the
> linux/pci-dma.h inclusion in arch's asm/pci.h
> 
> Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> Cc: Arnd Bergmann <arnd@arndb.de>

Acked-by: Arnd Bergmann <arnd@arndb.de>
