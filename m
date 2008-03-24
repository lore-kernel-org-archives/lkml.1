Return-Path: <linux-kernel-owner+w=401wt.eu-S1758817AbYCXLIL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758817AbYCXLIL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2008 07:08:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757651AbYCXLIE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Mar 2008 07:08:04 -0400
Received: from gateway.drzeus.cx ([85.8.24.16]:46694 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757611AbYCXLID (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2008 07:08:03 -0400
Date: Mon, 24 Mar 2008 13:07:57 +0100
From: Pierre Ossman <drzeus-list@drzeus.cx>
To: Carlos Aguiar <carlos.aguiar@indt.org.br>
Cc: Tony Lindgren <tony@atomide.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/18] MMC: OMAP: Remove some opcodes from host driver
Message-ID: <20080324130757.0e22bfef@mjolnir.drzeus.cx>
In-Reply-To: <47DAD3A1.9090702@indt.org.br>
References: <47DAD3A1.9090702@indt.org.br>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Mar 2008 15:36:01 -0400
Carlos Aguiar <carlos.aguiar@indt.org.br> wrote:

> From: Carlos Eduardo Aguiar <carlos.aguiar@indt.org.br>
> 
> This patch removes some opcodes from host driver so there's no need on putting
> '#include <linux/mmc/mmc.h>', that should not be needed in host drivers.
> 
> Signed-off-by: Carlos Eduardo Aguiar <carlos.aguiar@indt.org.br>
> ---

Looks good.

-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org
