Return-Path: <linux-kernel-owner+w=401wt.eu-S1754948AbZLION4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754948AbZLION4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 09:13:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754587AbZLIONz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 09:13:55 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:43486 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754025AbZLIONy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 09:13:54 -0500
Date: Wed, 9 Dec 2009 14:13:58 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Joe Perches <joe@perches.com>
Cc: Uwe Kleine-K?nig <u.kleine-koenig@pengutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: pass upstream rev to scripts/get_maintainer.pl
Message-ID: <20091209141357.GG9018@sirena.org.uk>
References: <20091209090639.GA23236@pengutronix.de> <1260367667.27319.11.camel@Joe-Laptop.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1260367667.27319.11.camel@Joe-Laptop.home>
X-Cookie: Include me out.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 09, 2009 at 06:07:47AM -0800, Joe Perches wrote:
> On Wed, 2009-12-09 at 10:06 +0100, Uwe Kleine-K??nig wrote:
> > I often face the "problem" that get_maintainer.pl yields my name, too,
> > as the commits I want to send are included in HEAD.

> Why is this a problem?

With the limit on the number of people returned it's possible that
authors of the patch series being posted (there may be more than one)
will push out folks that it'd be good to include.
