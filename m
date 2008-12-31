Return-Path: <linux-kernel-owner+w=401wt.eu-S1756521AbYLaR7m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756521AbYLaR7m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2008 12:59:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755830AbYLaR7d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Dec 2008 12:59:33 -0500
Received: from server.drzeus.cx ([85.8.24.28]:47762 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752598AbYLaR7c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2008 12:59:32 -0500
Date: Wed, 31 Dec 2008 18:59:28 +0100
From: Pierre Ossman <drzeus-mmc@drzeus.cx>
To: Tony Lindgren <tony@atomide.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.arm.linux.org.uk,
       linux-omap@vger.kernel.org, Madhusudhan Chikkature <madhu.cr@ti.com>,
       David Brownell <david-b@pacbell.net>
Subject: Re: [PATCH 5/5] omap mmc: Add new omap hsmmc controller for 2430
 and 34xx
Message-ID: <20081231185928.2ba325e6@mjolnir.drzeus.cx>
In-Reply-To: <20081230083624.GD7850@atomide.com>
References: <20081207213617.10456.43951.stgit@localhost>
	<20081207215139.10456.46405.stgit@localhost>
	<20081221171700.3efc0c3a@mjolnir.drzeus.cx>
	<20081229165531.GG22065@atomide.com>
	<20081230083624.GD7850@atomide.com>
X-Mailer: Claws Mail 3.6.0 (GTK+ 2.14.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Dec 2008 10:36:26 +0200
Tony Lindgren <tony@atomide.com> wrote:

> 
> Here's one more version that leaves out the unnecessary TWL4030
> dependency in the Kconfig as pointed out by David Brownell.
> 

Looks ok.

Acked-by: Pierre Ossman <drzeus@drzeus.cx>

-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  rdesktop, core developer          http://www.rdesktop.org

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.
