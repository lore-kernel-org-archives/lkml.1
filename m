Return-Path: <linux-kernel-owner+w=401wt.eu-S1761350AbYFFPPY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761350AbYFFPPY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 11:15:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757861AbYFFPPK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 11:15:10 -0400
Received: from mail.gmx.net ([213.165.64.20]:46017 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1757361AbYFFPPI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 11:15:08 -0400
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX1941C91IXp43FHuqrK6Y0GTRjop0TzPA0gHrxfcmQ
	3D5uttJWlRvVgD
Date: Fri, 6 Jun 2008 17:15:00 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@pengutronix.de>
X-X-Sender: lyakh@axis700.grange
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
cc: linux-kernel@vger.kernel.org, perex@perex.cz
Subject: Re: [PATCH] ac97: add support for wm9711 master left inv switch
In-Reply-To: <20080606150941.GF24872@sirena.org.uk>
Message-ID: <Pine.LNX.4.64.0806061714090.3338@axis700.grange>
References: <Pine.LNX.4.64.0806061659550.3338@axis700.grange>
 <20080606150941.GF24872@sirena.org.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 6 Jun 2008, Mark Brown wrote:

> On Fri, Jun 06, 2008 at 05:02:57PM +0200, Guennadi Liakhovetski wrote:
> > From: Juergen Beisert <j.beisert@pengutronix.de>
> > 
> > This patch adds support for Master Left Inv Switch on wm9711.
> > At least required to drive the mono speaker on the PXA270 platfrom
> > 
> > Signed-off-by: Juergen Beisert <j.beisert@pengutronix.de>
> 
> Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> 
> Note that ALSA patches should really be CCed to the alsa-devel mailing
> list (CC added).

MAINTAINERS:

L:      alsa-devel@alsa-project.org (subscribers-only)

(CC removed:-))

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
