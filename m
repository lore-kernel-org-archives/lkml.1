Return-Path: <linux-kernel-owner+w=401wt.eu-S1752407AbZA1T63@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752407AbZA1T63 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 14:58:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751172AbZA1T6V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 14:58:21 -0500
Received: from 82-117-125-11.tcdsl.calypso.net ([82.117.125.11]:36917 "EHLO
	smtp.drzeus.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751052AbZA1T6U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 14:58:20 -0500
Date: Wed, 28 Jan 2009 20:58:15 +0100
From: Pierre Ossman <drzeus-mmc@drzeus.cx>
To: Andy Whitcroft <apw@canonical.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] mmc: add MODALIAS linkage for MMC/SD devices
Message-ID: <20090128205815.3f0e60d6@mjolnir.drzeus.cx>
In-Reply-To: <20090128150639.GA31473@shadowen.org>
References: <1231268198-12556-1-git-send-email-apw@canonical.com>
	<20090112160519.3ba21848@mjolnir.drzeus.cx>
	<20090115150003.GB6896@shadowen.org>
	<20090124185612.5afddbb0@mjolnir.drzeus.cx>
	<ac3eb2510901241545l4eb9f77dvebd5861340b3447e@mail.gmail.com>
	<20090125164858.6b281c6c@mjolnir.drzeus.cx>
	<ac3eb2510901250800g40dd31d8q35e626413f2853a1@mail.gmail.com>
	<20090127201406.27c8592f@mjolnir.drzeus.cx>
	<ac3eb2510901271126o52eeb867q402d919c3ae6fa56@mail.gmail.com>
	<20090128150639.GA31473@shadowen.org>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Jan 2009 15:06:39 +0000
Andy Whitcroft <apw@canonical.com> wrote:

> 
> So asre we happy with the last textual patch or should I refactor back
> to mmc:block.
> 

I prefer "block" and a comment near the code so that noone
misinterprets the system as a normal device to driver mapping.

Rgds
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  rdesktop, core developer          http://www.rdesktop.org

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.
