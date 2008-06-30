Return-Path: <linux-kernel-owner+w=401wt.eu-S1759561AbYF3SKu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759561AbYF3SKu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 14:10:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760495AbYF3SKX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 14:10:23 -0400
Received: from server.drzeus.cx ([85.8.24.28]:46079 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758298AbYF3SKW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 14:10:22 -0400
Date: Mon, 30 Jun 2008 20:10:19 +0200
From: Pierre Ossman <drzeus-mmc@drzeus.cx>
To: Ben Dooks <ben-linux@fluff.org>
Cc: Harald Welte <laforge@openmoko.org>, Ben Dooks <ben-linux@fluff.org>,
       linux-kernel@vger.kernel.org, tk@maintech.de
Subject: Re: [patch v4 02/17] MMC: S3C24XX: Fix the checkpatch.pl errors in
 the s3cmci driver
Message-ID: <20080630201019.4af5dbf2@mjolnir.drzeus.cx>
In-Reply-To: <20080630170408.GE8489@trinity.fluff.org>
References: <20080630152547.755285683@fluff.org.uk>
	<20080630152747.132370982@fluff.org.uk>
	<20080630175018.356568b7@mjolnir.drzeus.cx>
	<20080630161537.GD8489@trinity.fluff.org>
	<20080630163601.GD5043@prithivi.gnumonks.org>
	<20080630170408.GE8489@trinity.fluff.org>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.13.3; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Jun 2008 18:04:08 +0100
Ben Dooks <ben-linux@fluff.org> wrote:

> 
> You have missed part of the point. My extra work is not a small
> set of changes which won't get counted when profiling the Kernel
> contributors. My employers have given me time to sort these
> items out, and we do get work off the fact that we're shown to be in
> the leading contributors (iirc, 18th last-year) so I was trying to
> ensure that this wasn't lost.
> 

I can appreciate that, but I do not want a commit in the tree that
doesn't even compile. You don't have to merge in all the other ones
(which should give you a reasonable blip in the statistics), but at
least #1 and #2.

-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  rdesktop, core developer          http://www.rdesktop.org

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.
