Return-Path: <linux-kernel-owner+w=401wt.eu-S1753848AbYAIMBd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753848AbYAIMBd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 07:01:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751128AbYAIMB0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 07:01:26 -0500
Received: from gateway.drzeus.cx ([85.8.24.16]:41933 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750920AbYAIMB0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 07:01:26 -0500
Date: Wed, 9 Jan 2008 13:01:23 +0100
From: Pierre Ossman <drzeus-list@drzeus.cx>
To: Sandeep K <san_kernel2008@yahoo.com>
Cc: linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: lba 28-bit addressing mode for MMC/SD card
Message-ID: <20080109130123.70d6ced9@poseidon.drzeus.cx>
In-Reply-To: <679831.85146.qm@web45707.mail.sp1.yahoo.com>
References: <679831.85146.qm@web45707.mail.sp1.yahoo.com>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.3; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Dec 2007 05:51:46 -0800 (PST)
Sandeep K <san_kernel2008@yahoo.com> wrote:

> Hi all,
> 
> does the linux kernel MMC block layer supports lba
> 28-bit 
> addressing mode for MMC/SD card ? 
> 

LBA is not a term used for MMC/SD, so I'm unsure what you're referring to. The MMC layer supports legacy cards, SDHC and MMC 4.2 addressing. All addresses are 32-bit.

Rgds
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org
