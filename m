Return-Path: <linux-kernel-owner+w=401wt.eu-S1761549AbZAOGkM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761549AbZAOGkM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 01:40:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753054AbZAOGj7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 01:39:59 -0500
Received: from 82-117-125-11.tcdsl.calypso.net ([82.117.125.11]:50378 "EHLO
	smtp.drzeus.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752350AbZAOGj6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 01:39:58 -0500
Date: Thu, 15 Jan 2009 07:39:55 +0100
From: Pierre Ossman <drzeus-mmc@drzeus.cx>
To: "Liu Dave" <DaveLiu@freescale.com>
Cc: avorontsov@ru.mvista.com, linuxppc-dev@ozlabs.org,
       "Lai Kon-LKL001" <Konjin.Lai@freescale.com>,
       linux-kernel@vger.kernel.org, "Xie Xiaobo-R63061" <X.Xie@freescale.com>,
       "D'Abbraccio Joe-LJD015" <Joe.D'abbraccio@freescale.com>
Subject: Re: [PATCH] mmc: Add driver for Freescale eSDHC controllers
Message-ID: <20090115073955.11d20734@mjolnir.drzeus.cx>
In-Reply-To: <D7CCA83BB0796C49BC0BB53B6AB1208907ACF9@zch01exm21.fsl.freescale.net>
References: <20090114194631.GA25978@oksana.dev.rtsoft.ru>
	<D7CCA83BB0796C49BC0BB53B6AB1208907ABDB@zch01exm21.fsl.freescale.net>
	<20090114235605.GA13531@oksana.dev.rtsoft.ru>
	<20090115065502.1b719b06@mjolnir.drzeus.cx>
	<D7CCA83BB0796C49BC0BB53B6AB1208907ACF9@zch01exm21.fsl.freescale.net>
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.14.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Jan 2009 14:11:09 +0800
"Liu Dave" <DaveLiu@freescale.com> wrote:

> > Probably because it was quicker. Samsung did the same thing, but now
> > Ben Dooks has patches to properly support it via sdhci.
> 
> Pierre,
> What samsung driver are you talking? Could you point it to me?
> 

I'm afraid I haven't seen any readily available sources for their
driver. If you meant Ben's version, you can find the latest revision
here:

http://marc.info/?t=122823266100005

Unfortunately marc.info didn't sort out the threading, but you should
be able to find all the patches there or some other LKML archive.

Rgds
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  rdesktop, core developer          http://www.rdesktop.org

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.
