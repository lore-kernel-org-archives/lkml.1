Return-Path: <linux-kernel-owner+w=401wt.eu-S1753378AbZHBWwx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753378AbZHBWwx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Aug 2009 18:52:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752895AbZHBWww
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Aug 2009 18:52:52 -0400
Received: from viefep20-int.chello.at ([62.179.121.40]:19364 "EHLO
	viefep20-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752753AbZHBWww (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Aug 2009 18:52:52 -0400
X-Greylist: delayed 1111 seconds by postgrey-1.27 at vger.kernel.org; Sun, 02 Aug 2009 18:52:51 EDT
X-SourceIP: 62.24.72.246
From: Pavel Pisa <ppisa@pikron.com>
To: Pierre Ossman <pierre@ossman.eu>
Subject: Re: [PATCH 26/62] drivers/mmc/host/imxmmc.c: Remove unnecessary semicolons
Date: Mon, 3 Aug 2009 00:34:11 +0200
User-Agent: KMail/1.9.9
Cc: Joe Perches <joe@perches.com>, linux-kernel@vger.kernel.org,
       trivial@kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Sascha Hauer <s.hauer@pengutronix.de>
References: <cover.1246173664.git.joe@perches.com> <d76aa5b943c6cd92a1a02565c681575ecac48678.1246173681.git.joe@perches.com> <20090731113026.5e025c94@mjolnir.ossman.eu>
In-Reply-To: <20090731113026.5e025c94@mjolnir.ossman.eu>
Organization: PiKRON Ltd.
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200908030034.11692.ppisa@pikron.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 31 July 2009 11:30:26 Pierre Ossman wrote:
> On Sun, 28 Jun 2009 09:26:31 -0700
>
> Joe Perches <joe@perches.com> wrote:
> > Signed-off-by: Joe Perches <joe@perches.com>
> > ---
> >  drivers/mmc/host/imxmmc.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> >
> > diff --git a/drivers/mmc/host/imxmmc.c b/drivers/mmc/host/imxmmc.c
> > index e0be21a..bf98d7c 100644
> > --- a/drivers/mmc/host/imxmmc.c
> > +++ b/drivers/mmc/host/imxmmc.c
> > @@ -652,7 +652,7 @@ static irqreturn_t imxmci_irq(int irq, void *devid)
> >  	set_bit(IMXMCI_PEND_STARTED_b, &host->pending_events);
> >  	tasklet_schedule(&host->tasklet);
> >
> > -	return IRQ_RETVAL(handled);;
> > +	return IRQ_RETVAL(handled);
> >  }
> >
> >  static void imxmci_tasklet_fnc(unsigned long data)
>
> Queued.

Hello Pierre,

I have already ACKed  this patch on some other mailing list.
But generally do not count with me much, because I have finish other
demanding things at company and university before could return
to great kernel playground.

I would like to send you BIG THANKS for all your MMC/SD related
work as well.

Best wishes,

              Pavel

--
              Pavel Pisa
    e-mail:     pisa@cmp.felk.cvut.cz
    www:        http://cmp.felk.cvut.cz/~pisa
    university: http://dce.felk.cvut.cz/
    company:    http://www.pikron.com/
