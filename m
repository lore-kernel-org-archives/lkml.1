Return-Path: <linux-kernel-owner+w=401wt.eu-S939596AbZDJShl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939596AbZDJShl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 14:37:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936422AbZDJSha
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 14:37:30 -0400
Received: from 82-117-125-11.tcdsl.calypso.net ([82.117.125.11]:35484 "EHLO
	smtp.ossman.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936105AbZDJSh3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 14:37:29 -0400
Date: Fri, 10 Apr 2009 20:37:26 +0200
From: Pierre Ossman <drzeus-mmc@drzeus.cx>
To: JosephChan@via.com.tw
Cc: linux-kernel@vger.kernel.org, arnd@arndb.de, ben-linux@fluff.org
Subject: Re: [Patch 1/1 v5] via-sdmmc: VIA MSP card reader driver support
Message-ID: <20090410203726.62a2848a@mjolnir.ossman.eu>
In-Reply-To: <20090410203520.6e43acb2@mjolnir.ossman.eu>
References: <C80EF34A3D2E494DBAF9AC29C7AE4EB808EBD84A@exchtp03.taipei.via.com.tw>
	<20090410203520.6e43acb2@mjolnir.ossman.eu>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.0; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 Apr 2009 20:35:20 +0200
Pierre Ossman <drzeus-mmc@drzeus.cx> wrote:

> On Wed, 1 Apr 2009 10:24:02 +0800
> JosephChan@via.com.tw wrote:
> 
> > Hi all,
> > 
> > The following patch provides VIA MSP SD/MMC card reader driver support.
> > This patch is based on 2.6.29 kernel.
> > Thanks to Pierre's suggestions.
> > Please feel free to contact me if any problem. Thanks in advanced.
> > 
> > In addition, the SPEC is available in VX800 Programming guide (Device 13 Function 0) on http://linux.via.com.tw
> > 
> 
> Looking good. There's just a few minor things. See below.
> 

And then there's also the matter of a MAINTAINERS entry so I know who
to shout at if there's any issues with this driver in the future. ;)

Rgds
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  rdesktop, core developer          http://www.rdesktop.org
  TigerVNC, core developer          http://www.tigervnc.org

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.
