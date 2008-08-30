Return-Path: <linux-kernel-owner+w=401wt.eu-S1755557AbYH3LXa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755557AbYH3LXa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2008 07:23:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751881AbYH3LXW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Aug 2008 07:23:22 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:51297 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751869AbYH3LXW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2008 07:23:22 -0400
Date: Sat, 30 Aug 2008 08:22:48 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: linux-kernel@vger.kernel.org
Subject: Fw: [PATCH 3/5] V4L/DVB: follow lspci device/vendor style
Message-ID: <20080830082248.6e27ae97@mchehab.chehab.org>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.13.6; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I'm forwarding this message to LKML, since the previous one got rejected there, due
to an error at CC list.

Cheers,
Mauro.

Forwarded message:

Date: Fri, 29 Aug 2008 17:57:56 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, H. Peter Anvin <hpa@zytor.com>, David Airlie <airlied@linux.ie>, Samuel Ortiz <samuel@sortiz.org>, Matthew Wilcox <matthew@wil.cx>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/5] V4L/DVB: follow lspci device/vendor style


On Mon, 25 Aug 2008 15:45:09 -0600
Bjorn Helgaas <bjorn.helgaas@hp.com> wrote:

> 
> Use "[%04x:%04x]" for PCI vendor/device IDs to follow the format
> used by lspci(8).
> 
I've applied at V4L/DVB ML and should add it at linux-next. Thanks.



Cheers,
Mauro




Cheers,
Mauro
