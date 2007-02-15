Return-Path: <linux-kernel-owner+w=401wt.eu-S966116AbXBOQwE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966116AbXBOQwE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 11:52:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966129AbXBOQwE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 11:52:04 -0500
Received: from 85.8.24.16.se.wasadata.net ([85.8.24.16]:42283 "EHLO
	smtp.drzeus.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966128AbXBOQwD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 11:52:03 -0500
Message-ID: <45D48FB6.80703@drzeus.cx>
Date: Thu, 15 Feb 2007 17:52:06 +0100
From: Pierre Ossman <drzeus-list@drzeus.cx>
User-Agent: Thunderbird 1.5.0.9 (X11/20070131)
MIME-Version: 1.0
To: Eugene Ilkov <e.ilkov@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: 2.6.20 mmc: problem with highspeed SD card
References: <e13597370702131746q6a5d8e79i2341f5eb9c59bf6e@mail.gmail.com>	 <45D3F41C.3020600@drzeus.cx> <e13597370702150417o3888b71dtcc42e38156b46918@mail.gmail.com>
In-Reply-To: <e13597370702150417o3888b71dtcc42e38156b46918@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eugene Ilkov wrote:
> PXAMCI: irq 00000004 stat 00002140

Hang on. PXAMCI is a MMC controller, right? Perhaps the MMC timings
aren't overlapping properly with the new stuff... I'm going to have to
recheck my diagrams.

Rgds

-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org

