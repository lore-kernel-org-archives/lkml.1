Return-Path: <linux-kernel-owner+w=401wt.eu-S1756964AbYFNOha@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756964AbYFNOha (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2008 10:37:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753057AbYFNOhT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jun 2008 10:37:19 -0400
Received: from server.drzeus.cx ([85.8.24.28]:60280 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752928AbYFNOhS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2008 10:37:18 -0400
Date: Sat, 14 Jun 2008 16:36:40 +0200
From: Pierre Ossman <drzeus-mmc@drzeus.cx>
To: avorontsov@ru.mvista.com
Cc: Marc Pignat <marc.pignat@hevs.ch>, Kumar Gala <galak@kernel.crashing.org>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Jochen Friedrich <jochen@scram.de>, Timur Tabi <timur@freescale.com>,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       spi-devel-general@lists.sourceforge.net
Subject: Re: [PATCH] mmc: toughen get_ro() and get_cd() return values
Message-ID: <20080614163640.01e89c51@mjolnir.drzeus.cx>
In-Reply-To: <20080605171013.GA10513@polina.dev.rtsoft.ru>
References: <20080523154204.GA19803@polina.dev.rtsoft.ru>
	<200806031207.49843.marc.pignat@hevs.ch>
	<20080605144310.GA31596@polina.dev.rtsoft.ru>
	<200806051759.00202.marc.pignat@hevs.ch>
	<20080605171013.GA10513@polina.dev.rtsoft.ru>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.13.2; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 5 Jun 2008 21:10:13 +0400
Anton Vorontsov <avorontsov@ru.mvista.com> wrote:

> 
> Pierre, I see you didn't yet pushed out the mmc tree, so.. would you
> prefer this patch folded into 0/3 series and resent?
> 

This works fine. :)

rgds
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  rdesktop, core developer          http://www.rdesktop.org

  WARNING: This correspondence is being monitored by the
  Swedish government. Use end-to-end encryption where
  possible.
