Return-Path: <linux-kernel-owner+w=401wt.eu-S1755314AbYISTPB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755314AbYISTPB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2008 15:15:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753718AbYISTOx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Sep 2008 15:14:53 -0400
Received: from smtpeu1.atmel.com ([195.65.72.27]:40080 "EHLO bagnes.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753699AbYISTOw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2008 15:14:52 -0400
Date: Fri, 19 Sep 2008 21:14:37 +0200
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: Mark Brown <broonie@sirena.org.uk>
Cc: lrg@slimlogic.co.uk, linux-kernel@vger.kernel.org,
       alsa-devel@alsa-project.org
Subject: Re: [PATCH] ASoC: Fix at32-pcm build breakage with PM enabled
Message-ID: <20080919211437.08db455c@hskinnemo-gx745.norway.atmel.com>
In-Reply-To: <20080919182036.GA16316@sirena.org.uk>
References: <1221843045-18093-1-git-send-email-haavard.skinnemoen@atmel.com>
	<20080919182036.GA16316@sirena.org.uk>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 19 Sep 2008 19:14:27.0834 (UTC) FILETIME=[EF89EDA0:01C91A8B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Brown <broonie@sirena.org.uk> wrote:
> On Fri, Sep 19, 2008 at 06:50:45PM +0200, Haavard Skinnemoen wrote:
> > s/PDC_PTCR/ATMEL_PDC_PTCR/
> > 
> > Signed-off-by: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
> 
> Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

Thanks.

> Please submit all ALSA patches to alsa-devel (added to the CC).

I would if it wasn't listed as subscribers-only...but from a closer
look, it appears like it's only moderated for non-subscribers. Should I
resend the patch?

Btw, Liam Girdwood's mail address from MAINTAINERS doesn't work.

Haavard
