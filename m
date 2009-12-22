Return-Path: <linux-kernel-owner+w=401wt.eu-S1753219AbZLVNDK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753219AbZLVNDK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Dec 2009 08:03:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753024AbZLVNDH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Dec 2009 08:03:07 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:36693 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753029AbZLVNDG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Dec 2009 08:03:06 -0500
Date: Tue, 22 Dec 2009 14:02:46 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: peterhuewe@gmx.de
Cc: Jiri Kosina <trivial@kernel.org>, kernel-janitors@vger.kernel.org,
       Jon Masters <jcm@jonmasters.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] misc: add __init/__exit macros to
	drivers/misc/hwlat_detector.c
Message-ID: <20091222130246.GA2368@pengutronix.de>
References: <1261470564-23754-1-git-send-email-peterhuewe@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1261470564-23754-1-git-send-email-peterhuewe@gmx.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, Dec 22, 2009 at 09:29:23AM +0100, peterhuewe@gmx.de wrote:
> From: Peter Huewe <peterhuewe@gmx.de>
> 
> Trivial patch which adds the __init/__exit macros to the module_init/
> module_exit functions of
> 
> drivers/misc/hwlat_detector.c
> 
> Please have a look at the small patch and either pull it through
> your tree, or please ack' it so Jiri can pull it through the trivial
> tree.
> 
> Patch against linux-next-tree, 22. Dez 08:38:18 CET 2009
> but also present in linus tree.
> 
> Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
> ---
The commit log contains some things that are maybe interesting in this
mail, but not in git (base tree, plea to look, exact filename).

Apart from Acked-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

Best regards
Uwe

-- 
Pengutronix e.K.                              | Uwe Kleine-König            |
Industrial Linux Solutions                    | http://www.pengutronix.de/  |
