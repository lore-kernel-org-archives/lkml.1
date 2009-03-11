Return-Path: <linux-kernel-owner+w=401wt.eu-S1751585AbZCKV0S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751585AbZCKV0S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 17:26:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750873AbZCKV0E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 17:26:04 -0400
Received: from 82-117-125-11.tcdsl.calypso.net ([82.117.125.11]:51559 "EHLO
	smtp.drzeus.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750770AbZCKV0D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 17:26:03 -0400
Date: Wed, 11 Mar 2009 22:25:54 +0100
From: Pierre Ossman <drzeus-mmc@drzeus.cx>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ben Dooks <ben@simtec.co.uk>, linux-kernel@vger.kernel.org
Subject: Re: s3cmci: fix s3c2410_dma_config() arguments.
Message-ID: <20090311222554.0be88156@mjolnir.ossman.eu>
In-Reply-To: <20090311133946.0fffc898.akpm@linux-foundation.org>
References: <20090310235711.185285440@fluff.org.uk>
	<20090311133946.0fffc898.akpm@linux-foundation.org>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.15.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Mar 2009 13:39:46 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> 
> This looks like 2.6.29 material?
> 
> mmc-in-mmc_power_up-use-previously-selected-ocr-if-available.patch also
> looks like 2.6.29 material to me, but Pierre isn't answering the phone.
> 

Sorry, it got lost in the noise. That patch isn't critical. It has been
working fine so far, so the only problem seems to be a bit of waster
energy.

> I'll scoot both these into Linus tomorrowish unless told otherwise.

Feel free to push this patch though. :)

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
