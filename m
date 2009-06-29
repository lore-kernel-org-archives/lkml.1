Return-Path: <linux-kernel-owner+w=401wt.eu-S1756468AbZF2S2b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756468AbZF2S2b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 14:28:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753643AbZF2S2X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 14:28:23 -0400
Received: from mail.gmx.net ([213.165.64.20]:58947 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753545AbZF2S2W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 14:28:22 -0400
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX18T+Bw4CRwTmC2RxfKaH6PnbRAeO9lhzc8MKWqCgT
	R90zlxKDMb6xDf
Date: Mon, 29 Jun 2009 20:28:33 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Pavel Machek <pavel@ucw.cz>
cc: Greg KH <greg@kroah.com>, kernel list <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
       Brian Swetland <swetland@google.com>
Subject: Re: HTC Dream camera support for staging
In-Reply-To: <20090629114339.GA25552@elf.ucw.cz>
Message-ID: <Pine.LNX.4.64.0906292027130.4500@axis700.grange>
References: <20090629114339.GA25552@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.64
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Jun 2009, Pavel Machek wrote:

> 
> This patch adds driver for HTC Dream camera. I guess driver is
> slightly higher quality than usual for staging/ , but it is fairly big
> and I don't feel like doing all the cleanups myself. Also some parts
> can probably be removed, as they did not end up in shipping hardware..
> 
> The driver is actually so big that I'll attach it gzipped, otherwise
> it would not pass maillist limits.

when this patch will be leaving the "staging" state, it will have to be 
converted to use v4l2-subdev API and submitted to linux-media.

> Signed-off-by: Pavel Machek <pavel@ucw.cz>
> Cc: Brian Swetland <swetland@google.com>

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
