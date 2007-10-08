Return-Path: <linux-kernel-owner+w=401wt.eu-S1754606AbXJHOTB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754606AbXJHOTB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2007 10:19:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752435AbXJHOSt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Oct 2007 10:18:49 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:58487 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752249AbXJHOSs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2007 10:18:48 -0400
Date: Mon, 8 Oct 2007 07:17:40 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: kernel list <linux-kernel@vger.kernel.org>
Subject: Re: irqbalance considered obsolete by powertop
Message-ID: <20071008071740.4987b5f1@laptopd505.fenrus.org>
In-Reply-To: <20071008072555.GA6316@elf.ucw.cz>
References: <20071008072555.GA6316@elf.ucw.cz>
Organization: Intel
X-Mailer: Claws Mail 3.0.1 (GTK+ 2.12.0; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 8 Oct 2007 09:25:55 +0200
Pavel Machek <pavel@ucw.cz> wrote:

> Hi!
> 
> Powertop tells me that irqbalance is obsolete/burns too much power,
> while it is default Y and its help test does not provide any clues:

it is obsoleted.. (by the userspace balancer)
> 
> Enable kernel irq balancing (IRQBALANCE) [Y/n/?] (NEW) ?
> 
> The default yes will allow the kernel to do irq load balancing.
> Saying no will keep the kernel from doing irq load balancing.
> 
> ...should the help text be updated?

that and the feature should probably be put in feature-removal
