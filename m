Return-Path: <linux-kernel-owner+w=401wt.eu-S1754798AbZHHH6P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754798AbZHHH6P (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Aug 2009 03:58:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754735AbZHHH6O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Aug 2009 03:58:14 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:42334 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754451AbZHHH6N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Aug 2009 03:58:13 -0400
Date: Sat, 8 Aug 2009 08:57:55 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
       rt-users <linux-rt-users@vger.kernel.org>, Takashi Iwai <tiwai@suse.de>,
       Jaroslav Kysela <perex@perex.cz>, Liam Girdwood <lrg@slimlogic.co.uk>,
       Ben Dooks <ben-linux@fluff.org>, Timur Tabi <timur@freescale.com>,
       Eric Miao <eric.miao@marvell.com>, alsa-devel@alsa-project.org
Message-ID: <20090808075754.GB4519@sirena.org.uk>
References: <20090807203939.GA19374@pengutronix.de>
 <1249677761-19470-2-git-send-email-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1249677761-19470-2-git-send-email-u.kleine-koenig@pengutronix.de>
X-Cookie: You will be awarded some great honor.
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 82.41.28.43
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 2/6] s3c2443-ac97: convert semaphore to mutex
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 07, 2009 at 10:42:37PM +0200, Uwe Kleine-König wrote:

> This fixes a build failure for 2.6.31-rc4-rt1 (ARCH=arm, s3c2410_defconfig):

Applied, thanks.
