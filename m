Return-Path: <linux-kernel-owner+w=401wt.eu-S1754028AbYGXQ5s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754028AbYGXQ5s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 12:57:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751797AbYGXQ5l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 12:57:41 -0400
Received: from smtpeu1.atmel.com ([195.65.72.27]:51370 "EHLO bagnes.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750930AbYGXQ5k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 12:57:40 -0400
Date: Thu, 24 Jul 2008 18:49:20 +0200
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: Jaswinder Singh <jaswinder@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       kernelnewbies <kernelnewbies@nl.linux.org>,
       David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH 4/22] avr32: Introducing asm/syscalls.h
Message-ID: <20080724184920.6c6e19e4@hskinnemo-gx745.norway.atmel.com>
In-Reply-To: <1216912079.15251.6.camel@jaswinder.satnam>
References: <1216592500.3679.14.camel@jaswinder.satnam>
	<1216592798.3679.22.camel@jaswinder.satnam>
	<1216592879.3679.24.camel@jaswinder.satnam>
	<1216593035.3679.27.camel@jaswinder.satnam>
	<1216596035.3679.95.camel@jaswinder.satnam>
	<20080724150911.5bf4372b@hskinnemo-gx745.norway.atmel.com>
	<1216912079.15251.6.camel@jaswinder.satnam>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 24 Jul 2008 16:50:03.0893 (UTC) FILETIME=[51E1B250:01C8EDAD]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jaswinder Singh <jaswinder@infradead.org> wrote:
> If you want to merge this patch in your tree then let me know.

Well, I'd rather have it go in along with the others through mm or
something. But if it doesn't depend on anything else, I can take it if
it makes things easier.

> I will fix above issues and send updated patch for avr32 tree.

That'd be great, thanks.

Haavard
