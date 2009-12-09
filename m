Return-Path: <linux-kernel-owner+w=401wt.eu-S1754260AbZLIPLO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754260AbZLIPLO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 10:11:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753992AbZLIPLM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 10:11:12 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:39642 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754128AbZLIPLK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 10:11:10 -0500
Date: Wed, 9 Dec 2009 15:11:15 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Joe Perches <joe@perches.com>
Cc: Uwe Kleine-K?nig <u.kleine-koenig@pengutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: pass upstream rev to scripts/get_maintainer.pl
Message-ID: <20091209151115.GB32223@rakim.wolfsonmicro.main>
References: <20091209090639.GA23236@pengutronix.de>
 <1260367667.27319.11.camel@Joe-Laptop.home>
 <20091209141357.GG9018@sirena.org.uk>
 <1260368582.27319.32.camel@Joe-Laptop.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1260368582.27319.32.camel@Joe-Laptop.home>
X-Cookie: Microbiology Lab:  Staph Only!
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 09, 2009 at 06:23:02AM -0800, Joe Perches wrote:
> On Wed, 2009-12-09 at 14:13 +0000, Mark Brown wrote:

> > With the limit on the number of people returned it's possible that
> > authors of the patch series being posted (there may be more than one)
> > will push out folks that it'd be good to include.

> You could use --git-max-maintainers=<value more than default>

Of course, for that use case the patch is just a potentially clearer
idiom for doing it.
