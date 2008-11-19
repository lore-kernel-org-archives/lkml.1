Return-Path: <linux-kernel-owner+w=401wt.eu-S1754263AbYKSSp3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754263AbYKSSp3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 13:45:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752788AbYKSSpV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 13:45:21 -0500
Received: from server.drzeus.cx ([85.8.24.28]:59690 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752672AbYKSSpU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 13:45:20 -0500
Date: Wed, 19 Nov 2008 19:45:17 +0100
From: Pierre Ossman <drzeus-mmc@drzeus.cx>
To: Nicolas Ferre <nicolas.ferre@atmel.com>,
       David Brownell <david-b@pacbell.net>
Cc: lkml <linux-kernel@vger.kernel.org>, peterz@infradead.org,
       Ingo Molnar <mingo@elte.hu>, Russell King <rmk@arm.linux.org.uk>,
       Nicolas Ferre <nicolas.ferre@rfo.atmel.com>,
       Andrew Victor <linux@maxim.org.za>
Subject: Re: [patch 2.6.28-rc2] at91_mci: workaround lockdep
Message-ID: <20081119194517.2b73d74f@mjolnir.drzeus.cx>
In-Reply-To: <4921394E.2000901@atmel.com>
References: <200810271426.27110.david-b@pacbell.net>
	<4921394E.2000901@atmel.com>
X-Mailer: Claws Mail 3.6.0 (GTK+ 2.14.4; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Nov 2008 10:28:46 +0100
Nicolas Ferre <nicolas.ferre@atmel.com> wrote:

> 
> Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
> 

Any side-effects besides from dmesg noise? IOW should I push for .28?

-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  rdesktop, core developer          http://www.rdesktop.org

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.
