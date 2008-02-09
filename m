Return-Path: <linux-kernel-owner+w=401wt.eu-S1757034AbYBIR5k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757034AbYBIR5k (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2008 12:57:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752764AbYBIR5c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Feb 2008 12:57:32 -0500
Received: from h155.mvista.com ([63.81.120.155]:5296 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751417AbYBIR5b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2008 12:57:31 -0500
Message-ID: <47ADE9BF.7020303@ru.mvista.com>
Date: Sat, 09 Feb 2008 20:58:23 +0300
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Adrian Bunk <bunk@kernel.org>, rmk@arm.linux.org.uk,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: ide/arm/bast-ide.c compile error
References: <20080209001515.GF6505@cs181133002.pp.htv.fi> <200802091905.24827.bzolnier@gmail.com>
In-Reply-To: <200802091905.24827.bzolnier@gmail.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bartlomiej Zolnierkiewicz wrote:

> Remove 'ide_hwif_t **hwif' argument from bastide_register()
> (together with write-only ifs[]).

> Cc: Adrian Bunk <bunk@kernel.org>
> Cc: Russell King <rmk@arm.linux.org.uk>
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

Acked-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>

MBR, Sergei
