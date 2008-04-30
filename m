Return-Path: <linux-kernel-owner+w=401wt.eu-S1761484AbYD3Jf4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761484AbYD3Jf4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 05:35:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756883AbYD3Jfr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 05:35:47 -0400
Received: from mail.gmx.net ([213.165.64.20]:59666 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756861AbYD3Jfq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 05:35:46 -0400
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX1/1iK4aD9j1bGxS2PqYOOgslMRugPfJiyxU0PJRSC
	TdC/EmcjFboUOX
Date: Wed, 30 Apr 2008 11:35:53 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [patch] video: fix SOC_CAMERA_MT9M001 build bug
In-Reply-To: <20080429170344.5a6d01bc@gaivota>
Message-ID: <Pine.LNX.4.64.0804301130230.5099@axis700.grange>
References: <20080428120032.GA23847@elte.hu> <Pine.LNX.4.64.0804281944100.10718@axis700.grange>
 <20080428193130.GC9907@elte.hu> <Pine.LNX.4.64.0804282138000.11449@axis700.grange>
 <20080428201105.GD15840@elte.hu> <Pine.LNX.4.64.0804291345050.5602@axis700.grange>
 <20080429170344.5a6d01bc@gaivota>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Apr 2008, Mauro Carvalho Chehab wrote:

> Send me a pull request with a patch reverting it and applying the proper one.
> I'll drop it from my patch series at -git.

Mauro, you should be able to get both fixes from

http://linuxtv.org/hg/~gliakhovetski/v4l-dvb

now...

Thanks
Guennadi
---
Guennadi Liakhovetski
