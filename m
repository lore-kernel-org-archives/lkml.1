Return-Path: <linux-kernel-owner+w=401wt.eu-S1755382AbYHQSBD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755382AbYHQSBD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2008 14:01:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752187AbYHQSAx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Aug 2008 14:00:53 -0400
Received: from server.drzeus.cx ([85.8.24.28]:33683 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752070AbYHQSAx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2008 14:00:53 -0400
Date: Sun, 17 Aug 2008 20:00:45 +0200
From: Pierre Ossman <drzeus-mmc@drzeus.cx>
To: Ben Dooks <ben-linux@fluff.org>
Cc: linux-kernel@vger.kernel.org, Ben Dooks <ben-linux@fluff.org>
Subject: Re: MMC: s3cmci: attach get_cd host ops
Message-ID: <20080817200045.64107ed3@mjolnir.drzeus.cx>
In-Reply-To: <20080812082449.729133366@fluff.org.uk>
References: <20080812082449.729133366@fluff.org.uk>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.13.6; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Aug 2008 09:24:50 +0100
Ben Dooks <ben-linux@fluff.org> wrote:

> Attach the routine to get_cd to allow the MMC core to find out whether
> there is a card present or not without the tedious process of trying to
> send commands to the card or not.
> 
> Signed-off-by: Ben Dooks <ben-linux@fluff.org>
> 

Applied.

-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  rdesktop, core developer          http://www.rdesktop.org

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.
