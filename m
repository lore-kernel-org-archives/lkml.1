Return-Path: <linux-kernel-owner+w=401wt.eu-S1946018AbXEAVDF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946018AbXEAVDF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 17:03:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946010AbXEAVDF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 17:03:05 -0400
Received: from mail.gmx.net ([213.165.64.20]:60356 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1946018AbXEAVDB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 17:03:01 -0400
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX19t3g0y/kRtLtsmm22Ac5jYTt5uBJtcQ4OQWjbKBd
	1B3SrqnMYsNVm0
Date: Tue, 1 May 2007 23:03:01 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Stefan Roese <ml@stefan-roese.de>
cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: Correct location for ADC/DAC drivers
In-Reply-To: <200705011435.45046.ml@stefan-roese.de>
Message-ID: <Pine.LNX.4.60.0705012301500.4972@poirot.grange>
References: <200705011435.45046.ml@stefan-roese.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 May 2007, Stefan Roese wrote:

> I'm in the stage of integrating some ADC and DAC drivers for the AMCC 405EZ 
> PPC and looking for the correct location to place these drivers in the Linux 
> source tree. The drivers are basically character-drivers, so my first thought 
> is to put them in "drivers/char/adc/foo.c" or "drivers/char/adc_foo.c". Is 
> this a good solution?

drivers/mfd following ucb1x00?

Thanks
Guennadi
---
Guennadi Liakhovetski
