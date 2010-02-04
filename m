Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933188Ab0BDUGq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 15:06:46 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:33902 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932906Ab0BDUGp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 15:06:45 -0500
Date: Thu, 4 Feb 2010 21:06:38 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: David Miller <davem@davemloft.net>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, 12o3l@tiscali.nl,
       rmk+kernel@arm.linux.org.uk, netdev@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH 9/9] net: move am79c961's probe function to
	.devinit.text
Message-ID: <20100204200638.GA3035@pengutronix.de>
References: <20100203150850.GA28815@kroah.com> <1265313417-5568-9-git-send-email-u.kleine-koenig@pengutronix.de> <20100204.120501.110961896.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100204.120501.110961896.davem@davemloft.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 04, 2010 at 12:05:01PM -0800, David Miller wrote:
> From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> Date: Thu,  4 Feb 2010 20:56:57 +0100
> 
> > @David Miller: this patch is in patchwork with State: Not Applicable.
> > Does that mean that netdev isn't the right tree for this patch?
> 
> I was under the impression that someone would pick up the
> whole set as a unit.
Ah, OK.  I hope Greg does exactly that now.

Thanks
Uwe

-- 
Pengutronix e.K.                              | Uwe Kleine-König            |
Industrial Linux Solutions                    | http://www.pengutronix.de/  |
