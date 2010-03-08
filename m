Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753649Ab0CHJxp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 04:53:45 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:60473 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753334Ab0CHJxm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 04:53:42 -0500
Date: Mon, 8 Mar 2010 10:53:37 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: dave b <db.pub.mail@gmail.com>
Cc: Daniel Mack <daniel@caiaq.de>, Mikael Pettersson <mikpe@it.uu.se>,
       linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: weirdness with compiling a 2.6.33 kernel on arm debian
Message-ID: <20100308095337.GB27502@pengutronix.de>
References: <25ae2d691003051958x72040b47g29d842f1d389a6cf@mail.gmail.com> <19346.6765.457769.167118@pilspetsen.it.uu.se> <25ae2d691003060224x67ab1c9au5102c8a22518aff@mail.gmail.com> <20100306104131.GV28972@buzzloop.caiaq.de> <25ae2d691003061705l5fc0bca7n4a07f558a0c410cf@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <25ae2d691003061705l5fc0bca7n4a07f558a0c410cf@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 07, 2010 at 12:05:21PM +1100, dave b wrote:
> Ok... however how should one test the memory of an arm machine? ...
> memtest is only for x86. *I am referring to the kernel memtest and not
> memtest86.
The easiest is:  rerun make and check if it fails at exactly the same
place.

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
