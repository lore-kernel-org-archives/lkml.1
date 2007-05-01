Return-Path: <linux-kernel-owner+w=401wt.eu-S1754645AbXEAORA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754645AbXEAORA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 10:17:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754662AbXEAOQm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 10:16:42 -0400
Received: from 85.8.24.16.se.wasadata.net ([85.8.24.16]:58046 "EHLO
	smtp.drzeus.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754442AbXEAOQ0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 10:16:26 -0400
Message-ID: <46374B5B.5000008@drzeus.cx>
Date: Tue, 01 May 2007 16:14:51 +0200
From: Pierre Ossman <drzeus-mmc@drzeus.cx>
User-Agent: Thunderbird 2.0.0.0 (X11/20070414)
MIME-Version: 1.0
To: Adrian Bunk <bunk@stusta.de>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [-mm patch] MMC: make tifm_sd_set_dma_data() static
References: <20070425225716.8e9b28ca.akpm@linux-foundation.org> <20070428191941.GP3468@stusta.de>
In-Reply-To: <20070428191941.GP3468@stusta.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> This patch makes the needlessly global tifm_sd_set_dma_data() static.
> 
> Signed-off-by: Adrian Bunk <bunk@stusta.de>
> 

Thanks, applied.

Rgds
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org
