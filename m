Return-Path: <linux-kernel-owner+w=401wt.eu-S1753941AbZFBNtg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753941AbZFBNtg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 09:49:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753249AbZFBNt3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 09:49:29 -0400
Received: from smtp.nokia.com ([192.100.105.134]:45755 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752345AbZFBNt2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 09:49:28 -0400
Subject: Re: [resending-2] [PATCH] [MTD] [NAND] Add OMAP2 / OMAP3 NAND 
 driver
From: Artem Bityutskiy <dedekind@infradead.org>
Reply-To: dedekind@infradead.org
To: vimal singh <vimalsingh@ti.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
In-Reply-To: <52785.192.168.10.89.1243833774.squirrel@dbdmail.itg.ti.com>
References: <52785.192.168.10.89.1243833774.squirrel@dbdmail.itg.ti.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 02 Jun 2009 16:48:00 +0300
Message-Id: <1243950480.5847.35.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 02 Jun 2009 13:48:01.0065 (UTC) FILETIME=[BEAA2990:01C9E388]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-06-01 at 10:52 +0530, vimal singh wrote:
> On Fri, May 15, 2009 at 6:38 PM, Artem Bityutskiy <dedekind@infradead.org> wrote:
> > On Thu, 2009-04-30 at 15:03 +0530, vimal singh wrote:
> >> This driver is present in the OMAP tree, now pushing it to MTD.
> >>
> >> Original author(s):
> >>        Jian Zhang <jzhang@ti.com>
> >>
> >> Signed-off-by: Vimal Singh <vimalsingh@ti.com>
> >> ---
> >>  drivers/mtd/nand/Kconfig  |    6
> >>  drivers/mtd/nand/Makefile |    1
> >>  drivers/mtd/nand/omap2.c  |  776
> ++++++++++++++++++++++++++++++++++++++++++++++
> >>  3 files changed, 783 insertions(+)
> >
> > Hi Thomas,
> >
> > would you please find a little time and Ack/Nack this
> > please?
> 
> Artem,
> This patch is still pending. This patch has already been reviewed by you and
> Andrew Morton. Seems like Thomas is not finding time to review this. What
> should be the next step about this?

Unfortunately, I do not think I'm able to really review your driver.
So all I can do for you is to put your driver to my l2-mtd-2.6.git
tree into the "dunno" branch, and let dwmw2 review it. Which I did.

-- 
Best regards,
Artem Bityutskiy (Битюцкий Артём)

