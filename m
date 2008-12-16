Return-Path: <linux-kernel-owner+w=401wt.eu-S1753616AbYLPDvV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753616AbYLPDvV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2008 22:51:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752156AbYLPDvJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Dec 2008 22:51:09 -0500
Received: from casper.infradead.org ([85.118.1.10]:57610 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751502AbYLPDvI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2008 22:51:08 -0500
Subject: Re: [PATCH] x86: irqinit_64.c declare init_ISA_irqs before they
	get used
From: Jaswinder Singh <jaswinder@infradead.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <86802c440812151153l25a2351ds5e0a8a648262759d@mail.gmail.com>
References: <1229362945.15326.16.camel@jaswinder.satnam>
	 <86802c440812151153l25a2351ds5e0a8a648262759d@mail.gmail.com>
Content-Type: text/plain; charset=utf8
Date: Tue, 16 Dec 2008 09:19:35 +0530
Message-Id: <1229399375.3348.4.camel@jaswinder.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-12-15 at 11:53 -0800, Yinghai Lu wrote:

> 
> not needed.
> 
> could change that to static for 64bit.
> 

Thanks for your suggestion.

I also CC '﻿[PATCH] x86: irqinit_64.c init_ISA_irqs should be static' to
you :-)

Thank you,

Jaswinder Singh.

