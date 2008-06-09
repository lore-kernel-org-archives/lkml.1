Return-Path: <linux-kernel-owner+w=401wt.eu-S1758486AbYFIFjR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758486AbYFIFjR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 01:39:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752004AbYFIFjF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 01:39:05 -0400
Received: from mail.gmx.net ([213.165.64.20]:57181 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752052AbYFIFjE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 01:39:04 -0400
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX19aPFxEGDZaWAqZ4vFDcFAe5E8lA4/TdkA5ZUxDHl
	YfUFbJfvYrCmEc
Date: Mon, 9 Jun 2008 07:39:10 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@pengutronix.de>
X-X-Sender: lyakh@axis700.grange
To: Andrew Morton <akpm@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, perex@perex.cz
Subject: Re: [PATCH] ac97: add support for wm9711 master left inv switch
In-Reply-To: <20080608170127.b9610d2e.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0806090737560.21763@axis700.grange>
References: <Pine.LNX.4.64.0806061659550.3338@axis700.grange>
 <20080608170127.b9610d2e.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 8 Jun 2008, Andrew Morton wrote:

> On Fri, 6 Jun 2008 17:02:57 +0200 (CEST) Guennadi Liakhovetski <g.liakhovetski@pengutronix.de> wrote:
> 
> > From: Juergen Beisert <j.beisert@pengutronix.de>
> > 
> > This patch adds support for Master Left Inv Switch on wm9711.
> > At least required to drive the mono speaker on the PXA270 platfrom
> > 
> > Signed-off-by: Juergen Beisert <j.beisert@pengutronix.de>
> 
> Please include your own signed-off-by when forwarding other people's patches.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@pengutronix.de>

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
