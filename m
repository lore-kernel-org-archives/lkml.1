Return-Path: <linux-kernel-owner+w=401wt.eu-S1756692AbYALPjV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756692AbYALPjV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jan 2008 10:39:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751732AbYALPjN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jan 2008 10:39:13 -0500
Received: from gateway.drzeus.cx ([85.8.24.16]:45615 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750808AbYALPjM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jan 2008 10:39:12 -0500
Date: Sat, 12 Jan 2008 16:39:08 +0100
From: Pierre Ossman <drzeus-mmc@drzeus.cx>
To: Robin Getz <rgetz@blackfin.uclinux.org>,
       "Bryan Wu" <cooloney.lkml@gmail.com>
Cc: "Mike Frysinger" <vapier.adi@gmail.com>,
       "Cai, Cliff" <Cliff.Cai@analog.com>, linux-kernel@vger.kernel.org
Subject: Re: [patch] split MMC_CAP_4_BIT_DATA
Message-ID: <20080112163908.2dd791a4@poseidon.drzeus.cx>
In-Reply-To: <200801120802.37259.rgetz@blackfin.uclinux.org>
References: <386072610801081832w2befcbafwe9215067f022ed5d@mail.gmail.com>
	<20080111103532.2789b74f@poseidon.drzeus.cx>
	<200801111252.02285.rgetz@blackfin.uclinux.org>
	<200801120802.37259.rgetz@blackfin.uclinux.org>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.4; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 12 Jan 2008 08:02:37 -0500
Robin Getz <rgetz@blackfin.uclinux.org> wrote:

> 
> According to the HW folks - it is exactly as Pierre indicated - in theory it 
> should work, 4-bit MMC requires usage of different set of commands as 
> compared to 4-bit SD, so it should be just software - although no one has 
> tested it yet.
> 
> So I guess this is back on Bryan/Cliff to make work....
> 
> Thanks for pushing back.
> 

It's what I do ;)

If you provide some dumps of your test runs next week, I'm sure I can help with some qualified guesses as to what the problem might be.

Rgds
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org
