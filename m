Return-Path: <linux-kernel-owner+w=401wt.eu-S1752958AbYAIHVo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752958AbYAIHVo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 02:21:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751081AbYAIHVh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 02:21:37 -0500
Received: from gateway.drzeus.cx ([85.8.24.16]:42436 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750921AbYAIHVg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 02:21:36 -0500
Date: Wed, 9 Jan 2008 08:21:32 +0100
From: Pierre Ossman <drzeus-mmc@drzeus.cx>
To: "Mike Frysinger" <vapier.adi@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [patch] split MMC_CAP_4_BIT_DATA
Message-ID: <20080109082132.001fd339@poseidon.drzeus.cx>
In-Reply-To: <8bd0f97a0801081344i55100937qc1ad178dd94c358b@mail.gmail.com>
References: <200801081329.39611.vapier.adi@gmail.com>
	<20080108202157.0b8d3393@poseidon.drzeus.cx>
	<200801081440.49683.vapier.adi@gmail.com>
	<20080108214946.03018d95@poseidon.drzeus.cx>
	<8bd0f97a0801081344i55100937qc1ad178dd94c358b@mail.gmail.com>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.3; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 Jan 2008 16:44:08 -0500
"Mike Frysinger" <vapier.adi@gmail.com> wrote:

> On Jan 8, 2008 3:49 PM, Pierre Ossman <drzeus-mmc@drzeus.cx> wrote:
> > So, again, if you feel that there is a hardware difference between 4-bit MMC and 4-bit SD then please elaborate as it is my understanding that they are identical.
> 
> you may be 100% correct, i have no idea, i'm not really familiar with
> MMC/SD/SDIO at all.

The patch adds complexity to the system. So until you can convince me that complexity is actually needed, I'm afraid the answer is NAK.

Rgds
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org
