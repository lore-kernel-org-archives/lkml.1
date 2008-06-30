Return-Path: <linux-kernel-owner+w=401wt.eu-S1761285AbYF3Pub@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761285AbYF3Pub (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 11:50:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752592AbYF3PuX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 11:50:23 -0400
Received: from server.drzeus.cx ([85.8.24.28]:45730 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752377AbYF3PuW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 11:50:22 -0400
Date: Mon, 30 Jun 2008 17:50:18 +0200
From: Pierre Ossman <drzeus-mmc@drzeus.cx>
To: Ben Dooks <ben-linux@fluff.org>
Cc: linux-kernel@vger.kernel.org, tk@maintech.de, laforge@openmoko.org,
       Ben Dooks <ben-linux@fluff.org>
Subject: Re: [patch v4 02/17] MMC: S3C24XX: Fix the checkpatch.pl errors in
 the s3cmci driver
Message-ID: <20080630175018.356568b7@mjolnir.drzeus.cx>
In-Reply-To: <20080630152747.132370982@fluff.org.uk>
References: <20080630152547.755285683@fluff.org.uk>
	<20080630152747.132370982@fluff.org.uk>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.13.3; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Jun 2008 16:25:49 +0100
Ben Dooks <ben-linux@fluff.org> wrote:

> Fix the checkpatch and other problems pointed out by
> akpm.
> 
> Signed-off-by: Ben Dooks <ben-linux@fluff.org>
> 

I prefer to have this one merged into 01 as you'll end up with a commit
that you cannot compile otherwise. Besides, running checkpatch is
something you do before submitting anyway, not as a separate cleanup. :)

-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  rdesktop, core developer          http://www.rdesktop.org

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.
