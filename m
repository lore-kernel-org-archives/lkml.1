Return-Path: <linux-kernel-owner+w=401wt.eu-S1755015AbZLIPT6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755015AbZLIPT6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 10:19:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754776AbZLIPT5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 10:19:57 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:47421 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754767AbZLIPT5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 10:19:57 -0500
Date: Wed, 9 Dec 2009 16:19:55 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Joe Perches <joe@perches.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: pass upstream rev to scripts/get_maintainer.pl
Message-ID: <20091209151954.GA1389@pengutronix.de>
References: <20091209090639.GA23236@pengutronix.de> <1260367667.27319.11.camel@Joe-Laptop.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1260367667.27319.11.camel@Joe-Laptop.home>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 09, 2009 at 06:07:47AM -0800, Joe Perches wrote:
> On Wed, 2009-12-09 at 10:06 +0100, Uwe Kleine-König wrote:
> > I often face the "problem" that get_maintainer.pl yields my name, too,
> > as the commits I want to send are included in HEAD.
> 
> Why is this a problem?
> 
> If you are using git send-email, does adding
> --suppress-cc=self solve it?
I use get_maintainer.pl to add Cc: entries to changelogs, not as cc-prog
of git send-email.  So the alternative solution is to use grep here.
Anyhow I consider the suggestion I pointed out nicer.

Best regards
Uwe

-- 
Pengutronix e.K.                              | Uwe Kleine-König            |
Industrial Linux Solutions                    | http://www.pengutronix.de/  |
