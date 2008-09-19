Return-Path: <linux-kernel-owner+w=401wt.eu-S1754877AbYISTU6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754877AbYISTU6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2008 15:20:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753486AbYISTUv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Sep 2008 15:20:51 -0400
Received: from slimlogic.co.uk ([89.16.172.20]:46489 "EHLO slimlogic.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751153AbYISTUu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2008 15:20:50 -0400
Subject: Re: [PATCH] ASoC: Fix at32-pcm build breakage with PM enabled
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Cc: Mark Brown <broonie@sirena.org.uk>, linux-kernel@vger.kernel.org,
       alsa-devel@alsa-project.org
In-Reply-To: <20080919211437.08db455c@hskinnemo-gx745.norway.atmel.com>
References: <1221843045-18093-1-git-send-email-haavard.skinnemoen@atmel.com>
	 <20080919182036.GA16316@sirena.org.uk>
	 <20080919211437.08db455c@hskinnemo-gx745.norway.atmel.com>
Content-Type: text/plain
Date: Fri, 19 Sep 2008 20:20:50 +0100
Message-Id: <1221852050.6892.155.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-09-19 at 21:14 +0200, Haavard Skinnemoen wrote:
> Mark Brown <broonie@sirena.org.uk> wrote:
> > On Fri, Sep 19, 2008 at 06:50:45PM +0200, Haavard Skinnemoen wrote:
> > > s/PDC_PTCR/ATMEL_PDC_PTCR/
> > > 
> > > Signed-off-by: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
> > 
> > Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> 
> Thanks.
> 
> > Please submit all ALSA patches to alsa-devel (added to the CC).
> 
> I would if it wasn't listed as subscribers-only...but from a closer
> look, it appears like it's only moderated for non-subscribers. Should I
> resend the patch?
> 
> Btw, Liam Girdwood's mail address from MAINTAINERS doesn't work.
> 

It's just been updated.
 
Patch went in yesterday !

Liam

