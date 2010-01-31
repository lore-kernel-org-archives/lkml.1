Return-Path: <linux-kernel-owner+w=401wt.eu-S1754139Ab0AaUNO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754139Ab0AaUNO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jan 2010 15:13:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753998Ab0AaUNN
	(ORCPT <rfc822;linux-kernel-outgoing-6734>);
	Sun, 31 Jan 2010 15:13:13 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:43521 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753921Ab0AaUNM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jan 2010 15:13:12 -0500
Date: Sun, 31 Jan 2010 21:13:00 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Michal Marek <mmarek@suse.cz>, Greg KH <greg@kroah.com>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, Greg KH <gregkh@suse.de>,
       linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
       Sean MacLennan <smaclennan@pikatech.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] platform_driver_register: warn if probe is in
	.init.text
Message-ID: <20100131201300.GA20892@pengutronix.de>
References: <20100122173846.GA11057@suse.de> <1264189758-7197-1-git-send-email-u.kleine-koenig@pengutronix.de> <87y6jnw6qa.fsf@devron.myhome.or.jp> <20100126084741.GC20792@pengutronix.de> <20100128011403.GB24068@kroah.com> <20100130204425.GA16345@pengutronix.de> <20100131160213.GA14896@merkur.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100131160213.GA14896@merkur.ravnborg.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

> Michael is handling kbuild stuff now and that may include modpost stuff.
> So added Michael - then you guys can decide way forward.
Then the F: patterns for kbuild in MAINTAINERS should be extended.
 
> The modpost patches looks OK at a quick view.
> You can consider adding:
> 
> Acked-by: Sam Ravnborg <sam@ravnborg.org>
Thanks,
Uwe

-- 
Pengutronix e.K.                              | Uwe Kleine-König            |
Industrial Linux Solutions                    | http://www.pengutronix.de/  |
