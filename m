Return-Path: <linux-kernel-owner+w=401wt.eu-S1750762AbXBKSE2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750762AbXBKSE2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Feb 2007 13:04:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750765AbXBKSE2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Feb 2007 13:04:28 -0500
Received: from 85.8.24.16.se.wasadata.net ([85.8.24.16]:41360 "EHLO
	smtp.drzeus.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750762AbXBKSE2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Feb 2007 13:04:28 -0500
Message-ID: <45CF5AB0.6080309@drzeus.cx>
Date: Sun, 11 Feb 2007 19:04:32 +0100
From: Pierre Ossman <drzeus-mmc@drzeus.cx>
User-Agent: Thunderbird 1.5.0.9 (X11/20070131)
MIME-Version: 1.0
To: Brad Campbell <brad@wasp.net.au>
CC: Alex Dubov <oakad@yahoo.com>, linux-kernel@vger.kernel.org
Subject: Re: Recent and not-so problems with tifm_sd driver - one more
References: <113489.35158.qm@web36703.mail.mud.yahoo.com> <45CDC22B.6040408@drzeus.cx> <45CEB1C9.5010103@wasp.net.au> <45CF3904.5070401@drzeus.cx> <45CF3CA3.1010704@wasp.net.au>
In-Reply-To: <45CF3CA3.1010704@wasp.net.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Brad Campbell wrote:
> 
> brad@bklaptop2:/$ find sys/devices | grep mmc
> sys/devices/pci0000:00/0000:00:1e.0/0000:06:05.3/tifm_sd0:3/mmc_host:mmc0
> 

This is strange. You should be getting more entries below that.

> /sys/block/mmcblk0/device

Where does this point?

Rgds
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org
