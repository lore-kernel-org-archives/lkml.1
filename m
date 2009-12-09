Return-Path: <linux-kernel-owner+w=401wt.eu-S1755973AbZLIOW6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755973AbZLIOW6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 09:22:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755074AbZLIOW5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 09:22:57 -0500
Received: from mail.perches.com ([173.55.12.10]:1035 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753828AbZLIOW4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 09:22:56 -0500
Subject: Re: pass upstream rev to scripts/get_maintainer.pl
From: Joe Perches <joe@perches.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Uwe Kleine-K?nig <u.kleine-koenig@pengutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
In-Reply-To: <20091209141357.GG9018@sirena.org.uk>
References: <20091209090639.GA23236@pengutronix.de>
	 <1260367667.27319.11.camel@Joe-Laptop.home>
	 <20091209141357.GG9018@sirena.org.uk>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 09 Dec 2009 06:23:02 -0800
Message-ID: <1260368582.27319.32.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-12-09 at 14:13 +0000, Mark Brown wrote:
> On Wed, Dec 09, 2009 at 06:07:47AM -0800, Joe Perches wrote:
> > On Wed, 2009-12-09 at 10:06 +0100, Uwe Kleine-K??nig wrote:
> > > I often face the "problem" that get_maintainer.pl yields my name, too,
> > > as the commits I want to send are included in HEAD.
> > Why is this a problem?
> With the limit on the number of people returned it's possible that
> authors of the patch series being posted (there may be more than one)
> will push out folks that it'd be good to include.

You could use --git-max-maintainers=<value more than default>


