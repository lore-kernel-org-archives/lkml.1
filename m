Return-Path: <linux-kernel-owner+w=401wt.eu-S1754701AbYLNR2t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754701AbYLNR2t (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2008 12:28:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753549AbYLNR2m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Dec 2008 12:28:42 -0500
Received: from server.drzeus.cx ([85.8.24.28]:51289 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753545AbYLNR2l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2008 12:28:41 -0500
Date: Sun, 14 Dec 2008 18:28:38 +0100
From: Pierre Ossman <drzeus-mmc@drzeus.cx>
To: avorontsov@ru.mvista.com
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       David Brownell <dbrownell@users.sourceforge.net>,
       Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH v2] mmc: Add mmc_vddrange_to_ocrmask() helper function
Message-ID: <20081214182838.26c931bf@mjolnir.drzeus.cx>
In-Reply-To: <20081201115320.GA10980@oksana.dev.rtsoft.ru>
References: <20081030195546.GA30645@oksana.dev.rtsoft.ru>
	<20081030195632.GB13640@oksana.dev.rtsoft.ru>
	<20081108215537.12cdf5f6@mjolnir.drzeus.cx>
	<20081126195417.GA26264@oksana.dev.rtsoft.ru>
	<20081130210648.77b8843a@mjolnir.drzeus.cx>
	<20081201115320.GA10980@oksana.dev.rtsoft.ru>
X-Mailer: Claws Mail 3.6.0 (GTK+ 2.14.4; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 1 Dec 2008 14:53:20 +0300
Anton Vorontsov <avorontsov@ru.mvista.com> wrote:

> 
> Though, the $subject patch could be merged anytime as it doesn't
> depend on anything else. So, if you'll merge it earlier, that will
> make things a bit easier: -1 patch to resend. ;-)
> 

Queued up. Will be sent once the merge window opens up.

Rgds
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  rdesktop, core developer          http://www.rdesktop.org

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.
