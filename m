Return-Path: <linux-kernel-owner+w=401wt.eu-S1753369AbZLVNbH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753369AbZLVNbH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Dec 2009 08:31:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753338AbZLVNbB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Dec 2009 08:31:01 -0500
Received: from dallas.jonmasters.org ([72.29.103.172]:43021 "EHLO
	dallas.jonmasters.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753313AbZLVNbA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Dec 2009 08:31:00 -0500
Subject: Re: [PATCH 1/2] misc: add __init/__exit macros to
 drivers/misc/hwlat_detector.c
From: Jon Masters <jonathan@jonmasters.org>
To: Uwe =?ISO-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: peterhuewe@gmx.de, Jiri Kosina <trivial@kernel.org>,
       kernel-janitors@vger.kernel.org, Jon Masters <jcm@jonmasters.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20091222130246.GA2368@pengutronix.de>
References: <1261470564-23754-1-git-send-email-peterhuewe@gmx.de>
	 <20091222130246.GA2368@pengutronix.de>
Content-Type: text/plain; charset="UTF-8"
Organization: World Organi[sz]ation of Broken Dreams
Date: Tue, 22 Dec 2009 08:30:34 -0500
Message-Id: <1261488634.2791.6.camel@tonnant>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 8BIT
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 127.0.0.1
X-SA-Exim-Mail-From: jonathan@jonmasters.org
X-SA-Exim-Scanned: No (on dallas.jonmasters.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-12-22 at 14:02 +0100, Uwe Kleine-König wrote:
> Hello,
> 
> On Tue, Dec 22, 2009 at 09:29:23AM +0100, peterhuewe@gmx.de wrote:
> > From: Peter Huewe <peterhuewe@gmx.de>
> > 
> > Trivial patch which adds the __init/__exit macros to the module_init/
> > module_exit functions of
> > 
> > drivers/misc/hwlat_detector.c
> > 
> > Please have a look at the small patch and either pull it through
> > your tree, or please ack' it so Jiri can pull it through the trivial
> > tree.
> > 
> > Patch against linux-next-tree, 22. Dez 08:38:18 CET 2009
> > but also present in linus tree.
> > 
> > Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
> > ---
> The commit log contains some things that are maybe interesting in this
> mail, but not in git (base tree, plea to look, exact filename).
> 
> Apart from Acked-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

I'll get to this later. Just spent 2 days (should have been 10 hours
door to door) traveling to the UK in the worst storms for ten years on
*both* sides of the atlantic. Currently rediscovering sleep ;)

Jon.


