Return-Path: <linux-kernel-owner+w=401wt.eu-S1758365AbZLPAt0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758365AbZLPAt0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 19:49:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758196AbZLPAtW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 19:49:22 -0500
Received: from mail.renesas.com ([202.234.163.13]:34795 "EHLO
	mail03.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756613AbZLPAtP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 19:49:15 -0500
X-AuditID: ac140386-0000000600003037-3e-4b282e727188
Date: Wed, 16 Dec 2009 09:48:49 +0900
From: Yoshihiro Shimoda <shimoda.yoshihiro@renesas.com>
Subject: Re: [PATCH] drivers/mtd/nand/sh_flctl.c: use resource_size()
In-reply-to: <BD79186B4FD85F4B8E60E381CAEE19090200EA68@mi8nycmail19.Mi8.com>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: kernel list <linux-kernel@vger.kernel.org>, linux-mtd@lists.infradead.org,
       David Woodhouse <dwmw2@infradead.org>
Message-id: <4B282E71.4010908@renesas.com>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
References: <BD79186B4FD85F4B8E60E381CAEE19090200EA68@mi8nycmail19.Mi8.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H Hartley Sweeten wrote:
> Use resource_size().
> 
> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
> Cc: David Woodhouse <dwmw2@infradead.org>
> Cc: Yoshihiro Shimoda <shimoda.yoshihiro@renesas.com>

Thank you for your patch!

Acked-by: Yoshihiro Shimoda <shimoda.yoshihiro@renesas.com>

Thanks,
Yoshihiro Shimoda

