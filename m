Return-Path: <linux-kernel-owner+w=401wt.eu-S1764128AbYDPRbs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764128AbYDPRbs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 13:31:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759659AbYDPRb1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 13:31:27 -0400
Received: from gateway.drzeus.cx ([85.8.24.16]:57174 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757956AbYDPRb0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 13:31:26 -0400
Date: Wed, 16 Apr 2008 19:30:21 +0200
From: Pierre Ossman <drzeus-mmc@drzeus.cx>
To: Adrian Bunk <bunk@kernel.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] make __mmc_release_bus() static
Message-ID: <20080416193021.7cf11b7d@mjolnir.drzeus.cx>
In-Reply-To: <20080413181547.GG2182@cs181133002.pp.htv.fi>
References: <20080413181547.GG2182@cs181133002.pp.htv.fi>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 13 Apr 2008 21:15:47 +0300
Adrian Bunk <bunk@kernel.org> wrote:

> This patch makes the needlessly global __mmc_release_bus() static.
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>
> 

Applied, thanks.


-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org
