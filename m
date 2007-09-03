Return-Path: <linux-kernel-owner+w=401wt.eu-S1757442AbXICJFE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757442AbXICJFE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2007 05:05:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753347AbXICJEx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Sep 2007 05:04:53 -0400
Received: from gateway.drzeus.cx ([85.8.24.16]:59397 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753171AbXICJEw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2007 05:04:52 -0400
Date: Mon, 3 Sep 2007 11:04:41 +0200
From: Pierre Ossman <drzeus-mmc@drzeus.cx>
To: Satyam Sharma <satyam@infradead.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -mm] drivers/mmc/core/bus.c: Fix unused var warning
Message-ID: <20070903110441.15572c4c@poseidon.drzeus.cx>
In-Reply-To: <alpine.LFD.0.999.0709030145060.29617@enigma.security.iitk.ac.in>
References: <alpine.LFD.0.999.0709022344550.27844@enigma.security.iitk.ac.i
 n>
	<alpine.LFD.0.999.0709030145060.29617@enigma.security.iitk.ac.in>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.11.6; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 3 Sep 2007 01:46:20 +0530 (IST)
Satyam Sharma <satyam@infradead.org> wrote:

> 
> drivers/mmc/core/bus.c: In function ‘mmc_bus_uevent’:
> drivers/mmc/core/bus.c:77: warning: unused variable ‘length’
> drivers/mmc/core/bus.c:77: warning: unused variable ‘i’
> 
> Signed-off-by: Satyam Sharma <satyam@infradead.org>
> 

That particular piece of code seems to be a war zone in -mm right now.
I'll leave it be until we start merging this upstream.

Rgds
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org
