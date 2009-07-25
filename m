Return-Path: <linux-kernel-owner+w=401wt.eu-S1752917AbZGYVDO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752917AbZGYVDO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jul 2009 17:03:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752681AbZGYVDN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Jul 2009 17:03:13 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:52684 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752667AbZGYVDM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jul 2009 17:03:12 -0400
Date: Sat, 25 Jul 2009 22:03:28 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Frans Pop <elendil@planet.nl>, torvalds@linux-foundation.org,
       ray-lk@madrabbit.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org,
       Sergey Senozhatsky <sergey.senozhatsky@mail.by>
Subject: Re: [Regression] kdesu broken
Message-ID: <20090725220328.6faa9b3b@lxorguk.ukuu.org.uk>
In-Reply-To: <200907252216.42889.rjw@sisk.pl>
References: <200907240145.31935.rjw@sisk.pl>
	<20090725124859.530d158b@lxorguk.ukuu.org.uk>
	<200907251602.49918.elendil@planet.nl>
	<200907252216.42889.rjw@sisk.pl>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Just out of curiosity ad for reference.
> > Has this issue already been reported to the KDE people? Any links to a bug 
> > report or discussions there?
> 
> Not that I know of.  It's probably worth reporting, though.

The EIO one hasn't because it isn't their bug, the other one has.

Alan
