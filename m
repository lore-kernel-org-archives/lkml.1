Return-Path: <linux-kernel-owner+w=401wt.eu-S1755415AbYGJHxo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755415AbYGJHxo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 03:53:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752030AbYGJHxg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 03:53:36 -0400
Received: from mail37.messagelabs.com ([216.82.244.163]:10993 "EHLO
	mail37.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751525AbYGJHxf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 03:53:35 -0400
X-VirusChecked: Checked
X-Env-Sender: Uwe.Kleine-Koenig@digi.com
X-Msg-Ref: server-5.tower-37.messagelabs.com!1215676414!4907300!1
X-StarScan-Version: 5.5.12.14.2; banners=-,-,-
X-Originating-IP: [66.77.174.14]
Date: Thu, 10 Jul 2008 09:53:29 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= <Uwe.Kleine-Koenig@digi.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Russell King <rmk+kernel@arm.linux.org.uk>
Subject: Re: [PATCH] Fix name of Russell King in various comments
Message-ID: <20080710075329.GA24598@digi.com>
References: <1214832433-11893-1-git-send-email-Uwe.Kleine-Koenig@digi.com> <20080709235131.9b28dd12.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080709235131.9b28dd12.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-OriginalArrivalTime: 10 Jul 2008 07:53:30.0438 (UTC) FILETIME=[0B4DCE60:01C8E262]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Mon, 30 Jun 2008 15:27:13 +0200 Uwe Kleine-K__nig <Uwe.Kleine-Koenig@digi.com> wrote:
> 
> > This patch was created by
> >
> >       git grep -E -l 'Rus(el|s?e)l King' | xargs -r -t perl -p -i -e 's/Rus(el|s?e)l King/Russell King/g'
> >
> > Cc: Russell King <rmk+kernel@arm.linux.org.uk>
> > Signed-off-by: Uwe Kleine-K__nig <Uwe.Kleine-Koenig@digi.com>
> > ---
> >  drivers/usb/host/ohci-au1xxx.c  |    2 +-
> >  drivers/usb/host/ohci-lh7a404.c |    2 +-
> >  drivers/usb/host/ohci-s3c2410.c |    2 +-
> >  drivers/usb/host/ohci-sa1111.c  |    2 +-
> >  include/asm-avr32/setup.h       |    2 +-
> >  5 files changed, 5 insertions(+), 5 deletions(-)
> >
> > diff --git a/drivers/usb/host/ohci-au1xxx.c b/drivers/usb/host/ohci-au1xxx.c
> > index 1b9abdb..2ec3584 100644
> > --- a/drivers/usb/host/ohci-au1xxx.c
> > +++ b/drivers/usb/host/ohci-au1xxx.c
> > @@ -8,7 +8,7 @@
> >   * Bus Glue for AMD Alchemy Au1xxx
> >   *
> >   * Written by Christopher Hoover <ch@hpl.hp.com>
> > - * Based on fragments of previous driver by Rusell King et al.
> > + * Based on fragments of previous driver by Russell King et al.
> 
> Would the patch be smaller if we switched over to "Rusell" everywhere?
I think no, the patch would be bigger.  Even if you would only change
all occurences of "Russell King" to "Rusell King" this would affect ~500
lines in my working copy. :-)

> If so, we may as well do that.
So no. :-)  Moreover as I'm a bit sensitive for misspellings of my name,
too, I definitly support the patch as is.

Best regards
Uwe

-- 
Uwe Kleine-König, Software Engineer
Digi International GmbH Branch Breisach, Küferstrasse 8, 79206 Breisach, Germany
Tax: 315/5781/0242 / VAT: DE153662976 / Reg. Amtsgericht Dortmund HRB 13962
