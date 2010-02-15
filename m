Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756217Ab0BOTbX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Feb 2010 14:31:23 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:44702 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756116Ab0BOTbW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Feb 2010 14:31:22 -0500
Date: Mon, 15 Feb 2010 20:31:14 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Alberto Panizzo <maramaopercheseimorto@gmail.com>
Cc: Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       Sascha linux-arm <s.hauer@pengutronix.de>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Russell King - ARM Linux <linux@arm.linux.org.uk>,
       Greg KH <gregkh@suse.de>
Subject: Re: Subject: [PATCH] w1: mxc_w1: move probe and remove to the dev*
	text area.
Message-ID: <20100215193114.GA341@pengutronix.de>
References: <1266259741.2551.64.camel@realization>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1266259741.2551.64.camel@realization>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Albert,

On Mon, Feb 15, 2010 at 07:49:01PM +0100, Alberto Panizzo wrote:
> This fixes the section mismatch warning for mxc_w1_probe()
Acked-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

> ---
> 
> This patch apply to linus 2.6.33-rc8 tree.
> I think that could be marked for stable releases.
hmmm, if you'd know how much effort I spend to get patches like these in
...  Obviously letting modpost warn about those helps me getting
supporters :-)

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
