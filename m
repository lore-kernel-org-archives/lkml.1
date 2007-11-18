Return-Path: <linux-kernel-owner+w=401wt.eu-S1755530AbXKRWhV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755530AbXKRWhV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Nov 2007 17:37:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753349AbXKRWhG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Nov 2007 17:37:06 -0500
Received: from mail.gmx.net ([213.165.64.20]:35859 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753342AbXKRWhF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Nov 2007 17:37:05 -0500
X-Authenticated: #24222693
X-Provags-ID: V01U2FsdGVkX18Rn0cHRSoRnwf7eK1iG3eN8XAQ9+jpyjR5gwclA9
	fpnqfbyk6QAfLm
From: Robert Gerlach <khnz@gmx.de>
To: Stephen Hemminger <shemminger@linux-foundation.org>
Subject: Re: [PATCH] Fujitsu application panel driver
Date: Sun, 18 Nov 2007 23:36:58 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Dmitry Torokhov <dtor@insightbb.com>, Pavel Machek <pavel@ucw.cz>,
       Len Brown <lenb@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
       linux-input@atrey.karlin.mff.cuni.cz, linux-kernel@vger.kernel.org
References: <20070702111724.43ee5b43@freepuppy.localdomain.hemminger.net> <200709161623.00286.dtor@insightbb.com> <20071023125555.38d63567@shemminger-laptop>
In-Reply-To: <20071023125555.38d63567@shemminger-laptop>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711182336.59312.khnz@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag 23 Oktober 2007 21:55:55 schrieb Stephen Hemminger:
> +MODULE_ALIAS("dmi:*:svnFUJITSU:pnLifeBook*:pvr*:rvnFUJITSU:*");
> +MODULE_ALIAS("dmi:*:svnFUJITSU:pnLifebook*:pvr*:rvnFUJITSU:*");

Please make sure that this module is not autoload on Lifebook tablets (T 
series and P1[56]10). It works fine, but only supports a subset of features 
(4 of 7 buttons and no display orientation for my T4010).

Thanks,
  Robert
