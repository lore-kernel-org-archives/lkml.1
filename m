Return-Path: <linux-kernel-owner+w=401wt.eu-S1754222AbYCOPCR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754222AbYCOPCR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Mar 2008 11:02:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751872AbYCOPCH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Mar 2008 11:02:07 -0400
Received: from gateway.drzeus.cx ([85.8.24.16]:49138 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751861AbYCOPCG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Mar 2008 11:02:06 -0400
Date: Sat, 15 Mar 2008 16:01:27 +0100
From: Pierre Ossman <drzeus-mmc@drzeus.cx>
To: Roel Kluin <12o3l@tiscali.nl>
Cc: Alex Dubov <oakad@yahoo.com>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] MMC: DATA_CARRY is not boolean in
 tifm_sd_transfer_data() (was: MMC: logical-bitwise and confusion in 
 tifm_sd_transfer_data()?)
Message-ID: <20080315160127.2184bdc6@mjolnir.drzeus.cx>
In-Reply-To: <47D63C29.90304@tiscali.nl>
References: <854975.87080.qm@web36710.mail.mud.yahoo.com>
	<47D63C29.90304@tiscali.nl>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Mar 2008 09:00:41 +0100
Roel Kluin <12o3l@tiscali.nl> wrote:

> Alex Dubov wrote:
> > 
> > Yes, this is the intended meaning. Can you fix it yourself or should I send a separate patch?
> 
> Thanks,
> ---
> DATA_CARRY is not boolean
> 
> Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
> ---

Sorry about the delay. I've sent this off to Linus now.

Rgds
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org
