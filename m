Return-Path: <linux-kernel-owner+w=401wt.eu-S965574AbXA3QMS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965574AbXA3QMS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 11:12:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965578AbXA3QMS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 11:12:18 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:58581 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S965574AbXA3QMR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 11:12:17 -0500
Date: Tue, 30 Jan 2007 16:21:51 +0000
From: Alan <alan@lxorguk.ukuu.org.uk>
To: Jean Delvare <jdelvare@suse.de>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>, Sergey Vlasov <vsu@altlinux.ru>,
       Daniel Drake <dsd@reactivated.net>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@stusta.de>, Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH] VIA IRQ quirk breakage fix
Message-ID: <20070130162151.2a0e8bf1@localhost.localdomain>
In-Reply-To: <200701301449.52147.jdelvare@suse.de>
References: <45B6A94A.3010006@yahoo.com.au>
	<200701301325.58843.jdelvare@suse.de>
	<45BF4A3A.2040001@yahoo.com.au>
	<200701301449.52147.jdelvare@suse.de>
X-Mailer: Claws Mail 2.7.1 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Jan 2007 14:49:51 +0100
Jean Delvare <jdelvare@suse.de> wrote:
> I do believe this is 2.6.20 material. Given that Alan's version doesn't work 
> _at all_, my patch can only help. The real regression is between 2.6.19 and 
> the current Linus tree (with Alan's quirk.)

I believe my version works for all but the 686B

> > Andrew, can you pick up this patch in place of the old one you got
> > (fix-via-irq-quirk-breakage.patch). It was sent to lkml just now.
> 
> Yes, please. And possibly send it over to Linus while you're there, if 
> everyone's happy with this version.

Agreed.

Alan
