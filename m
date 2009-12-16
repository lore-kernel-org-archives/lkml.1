Return-Path: <linux-kernel-owner+w=401wt.eu-S1762791AbZLPSWa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762791AbZLPSWa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 13:22:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762764AbZLPSWT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 13:22:19 -0500
Received: from doppler.zen.co.uk ([212.23.3.27]:46907 "EHLO doppler.zen.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762763AbZLPSWR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 13:22:17 -0500
Message-ID: <4B2924F3.5060400@csr.com>
Date: Wed, 16 Dec 2009 18:20:35 +0000
From: David Vrabel <david.vrabel@csr.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Uwe_Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
CC: Anton Vorontsov <avorontsov@ru.mvista.com>, linux-kernel@vger.kernel.org,
       Greg Kroah-Hartman <gregkh@suse.de>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Grant Likely <grant.likely@secretlab.ca>,
       Kumar Gala <galak@kernel.crashing.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       spi-devel-general@lists.sourceforge.net,
       Linus Torvalds <torvalds@linux-foundation.org>
References: <1260979809-24811-1-git-send-email-u.kleine-koenig@pengutronix.de> <1260979809-24811-2-git-send-email-u.kleine-koenig@pengutronix.de> <1260979809-24811-3-git-send-email-u.kleine-koenig@pengutronix.de> <1260979809-24811-4-git-send-email-u.kleine-koenig@pengutronix.de> <1260979809-24811-5-git-send-email-u.kleine-koenig@pengutronix.de> <1260979809-24811-6-git-send-email-u.kleine-koenig@pengutronix.de> <20091216163229.GA26350@oksana.dev.rtsoft.ru> <20091216174904.GB26325@pengutronix.de>
In-Reply-To: <20091216174904.GB26325@pengutronix.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 82.70.146.43
X-SA-Exim-Mail-From: david.vrabel@csr.com
Subject: Re: [PATCH 6/7] spi/mpc8xxx: don't check platform_get_irq's return
 value against zero
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:20:07 +0000)
X-SA-Exim-Scanned: Yes (on localhost)
X-Originating-Smarthost03-IP: [82.70.146.41]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Uwe Kleine-König wrote:
> Hello,
> 
> [Note the email address used for David Vrabel isn't valid any more,
> this mail uses his last used address.]

I've not been involved in PXA27x stuff for years.  Please drop me from 
the CC, thanks.

David
