Return-Path: <linux-kernel-owner+w=401wt.eu-S1756472AbYH0TBT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756472AbYH0TBT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 15:01:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752320AbYH0TBK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 15:01:10 -0400
Received: from server.drzeus.cx ([85.8.24.28]:33705 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751964AbYH0TBJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 15:01:09 -0400
Date: Wed, 27 Aug 2008 21:01:05 +0200
From: Pierre Ossman <drzeus-mmc@drzeus.cx>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
       David Brownell <david-b@pacbell.net>,
       Nicolas Ferre <nicolas.ferre@atmel.com>,
       lkml <linux-kernel@vger.kernel.org>, Andrew Victor <linux@maxim.org.za>,
       Russell King <rmk@arm.linux.org.uk>
Subject: Re: [patch 2.6.27-rc3] at91_mci: don't use coherent dma buffers
Message-ID: <20080827210105.43d5aed2@mjolnir.drzeus.cx>
In-Reply-To: <48AE7B7E.1010503@atmel.com>
References: <200808181607.21516.david-b@pacbell.net>
	<48AE6D50.4030609@atmel.com>
	<48AE7B7E.1010503@atmel.com>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.13.6; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Aug 2008 10:40:30 +0200
Nicolas Ferre <nicolas.ferre@atmel.com> wrote:

> >>
> >> Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
> > 
> > ...
> 
> Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
> 

I have nothing else in my queue, so Andrew, as I suspect you have other
things going to Linus, if you could please include this one as well. :)

Acked-by: Pierre Ossman <drzeus@drzeus.cx>

Rgds
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  rdesktop, core developer          http://www.rdesktop.org

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.
