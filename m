Return-Path: <linux-kernel-owner+w=401wt.eu-S1754239AbZFAFXk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754239AbZFAFXk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 01:23:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751199AbZFAFXc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 01:23:32 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:36625 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750949AbZFAFXb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 01:23:31 -0400
Message-ID: <52785.192.168.10.89.1243833774.squirrel@dbdmail.itg.ti.com>
Date: Mon, 1 Jun 2009 10:52:54 +0530 (IST)
Subject: Re: [resending-2] [PATCH] [MTD] [NAND] Add OMAP2 / OMAP3 NAND 
     driver
From: "vimal singh" <vimalsingh@ti.com>
To: dedekind@infradead.org
Cc: "Thomas Gleixner" <tglx@linutronix.de>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.3a
X-Mailer: SquirrelMail/1.4.3a
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 15, 2009 at 6:38 PM, Artem Bityutskiy <dedekind@infradead.org> wrote:
> On Thu, 2009-04-30 at 15:03 +0530, vimal singh wrote:
>> This driver is present in the OMAP tree, now pushing it to MTD.
>>
>> Original author(s):
>>        Jian Zhang <jzhang@ti.com>
>>
>> Signed-off-by: Vimal Singh <vimalsingh@ti.com>
>> ---
>>  drivers/mtd/nand/Kconfig  |    6
>>  drivers/mtd/nand/Makefile |    1
>>  drivers/mtd/nand/omap2.c  |  776
++++++++++++++++++++++++++++++++++++++++++++++
>>  3 files changed, 783 insertions(+)
>
> Hi Thomas,
>
> would you please find a little time and Ack/Nack this
> please?

Artem,
This patch is still pending. This patch has already been reviewed by you and
Andrew Morton. Seems like Thomas is not finding time to review this. What
should be the next step about this?

Andrew has already given his signed-off for this patch:
http://lists.infradead.org/pipermail/linux-mtd/2009-May/025562.html

-- 
Regards,
Vimal

