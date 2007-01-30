Return-Path: <linux-kernel-owner+w=401wt.eu-S965667AbXA3SEK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965667AbXA3SEK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 13:04:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965669AbXA3SEJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 13:04:09 -0500
Received: from smtp.osdl.org ([65.172.181.24]:40614 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965667AbXA3SEI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 13:04:08 -0500
Date: Tue, 30 Jan 2007 10:02:12 -0800
From: Andrew Morton <akpm@osdl.org>
To: Jean Delvare <jdelvare@suse.de>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>, Sergey Vlasov <vsu@altlinux.ru>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Daniel Drake <dsd@reactivated.net>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@stusta.de>
Subject: Re: [PATCH] VIA IRQ quirk breakage fix
Message-Id: <20070130100212.1319d20e.akpm@osdl.org>
In-Reply-To: <200701301449.52147.jdelvare@suse.de>
References: <45B6A94A.3010006@yahoo.com.au>
	<200701301325.58843.jdelvare@suse.de>
	<45BF4A3A.2040001@yahoo.com.au>
	<200701301449.52147.jdelvare@suse.de>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Jan 2007 14:49:51 +0100
Jean Delvare <jdelvare@suse.de> wrote:

> > Andrew, can you pick up this patch in place of the old one you got
> > (fix-via-irq-quirk-breakage.patch). It was sent to lkml just now.
> 
> Yes, please. And possibly send it over to Linus while you're there, if 
> everyone's happy with this version.

I shall do so, thanks.
