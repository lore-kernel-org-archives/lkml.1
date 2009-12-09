Return-Path: <linux-kernel-owner+w=401wt.eu-S967000AbZLIAhC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967000AbZLIAhC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 19:37:02 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966987AbZLIAhA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 19:37:00 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58450 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966979AbZLIAhA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 19:37:00 -0500
Date: Tue, 8 Dec 2009 16:35:46 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Uwe =?ISO-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
       spi-devel-general@lists.sourceforge.net,
       David Brownell <dbrownell@users.sourceforge.net>,
       Sascha Hauer <s.hauer@pengutronix.de>, Daniel Mack <daniel@caiaq.de>,
       linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/5] spi-imx: some updates
Message-Id: <20091208163546.3354a7f5.akpm@linux-foundation.org>
In-Reply-To: <fa686aa40912081625y3750a7fegbac38926182e38c6@mail.gmail.com>
References: <20091208211258.GA13706@pengutronix.de>
	<20091208153239.af0b5bb8.akpm@linux-foundation.org>
	<fa686aa40912081625y3750a7fegbac38926182e38c6@mail.gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 Dec 2009 17:25:59 -0700
Grant Likely <grant.likely@secretlab.ca> wrote:

> I'm new to the job, so I'm being cautions about which things I'm pick
> up.  However, I'll happily merge anything that Andrew says is okay.

oop.  If I'm going to send a patch to a subsystem maintainer I'll usually give
it less attention than the ones I plan to merge myself.

Oh well, at least this way people will get their patches merged easily ;)

> Andrew, when in the merge window do you typically send out patch
> queues?

Late.  I stage the -mm patches after linux-next so I spend most of the
merge window waiting for people to get their stuff into mainline.

Often there are stragglers who I need to route around.  It's usually
not a significant problem though.
