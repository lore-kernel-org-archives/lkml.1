Return-Path: <linux-kernel-owner+w=401wt.eu-S1756032AbYKTPnS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756032AbYKTPnS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 10:43:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754895AbYKTPnF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 10:43:05 -0500
Received: from server.drzeus.cx ([85.8.24.28]:54445 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754894AbYKTPnE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 10:43:04 -0500
Date: Thu, 20 Nov 2008 16:42:58 +0100
From: Pierre Ossman <drzeus-mmc@drzeus.cx>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: David Brownell <david-b@pacbell.net>, lkml <linux-kernel@vger.kernel.org>,
       peterz@infradead.org, Ingo Molnar <mingo@elte.hu>,
       Russell King <rmk@arm.linux.org.uk>,
       Nicolas Ferre <nicolas.ferre@rfo.atmel.com>,
       Andrew Victor <linux@maxim.org.za>
Subject: Re: [patch 2.6.28-rc2] at91_mci: workaround lockdep
Message-ID: <20081120164258.31f51cdc@mjolnir.drzeus.cx>
In-Reply-To: <49257C13.2080304@atmel.com>
References: <200810271426.27110.david-b@pacbell.net>
	<4921394E.2000901@atmel.com>
	<20081119194517.2b73d74f@mjolnir.drzeus.cx>
	<49257C13.2080304@atmel.com>
X-Mailer: Claws Mail 3.6.0 (GTK+ 2.14.4; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Nov 2008 16:02:43 +0100
Nicolas Ferre <nicolas.ferre@atmel.com> wrote:

> Pierre Ossman :
> > On Mon, 17 Nov 2008 10:28:46 +0100
> > Nicolas Ferre <nicolas.ferre@atmel.com> wrote:
> > 
> >> Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
> >>
> > 
> > Any side-effects besides from dmesg noise? IOW should I push for .28?
> 
> No side-effect. I advice you to push it for .28-final.
> 

Well, considering Linus' recent clarification I was thinking more along
the lines that if the only thing it "solves" is some dmesg noise, then
it can wait for .29. :)

-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  rdesktop, core developer          http://www.rdesktop.org

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.
