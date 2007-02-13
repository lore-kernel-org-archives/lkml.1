Return-Path: <linux-kernel-owner+w=401wt.eu-S1750698AbXBMOvd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750698AbXBMOvd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 09:51:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750704AbXBMOvd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 09:51:33 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:48381 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750698AbXBMOvc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 09:51:32 -0500
Date: Tue, 13 Feb 2007 15:03:19 +0000
From: Alan <alan@lxorguk.ukuu.org.uk>
To: Theodore Tso <tytso@mit.edu>
Cc: "Martin A. Fink" <fink@mpe.mpg.de>, linux-kernel@vger.kernel.org
Subject: Re: SATA-performance: Linux vs. FreeBSD
Message-ID: <20070213150319.04164761@localhost.localdomain>
In-Reply-To: <20070213144702.GD8670@thunk.org>
References: <200702121502.17130.fink@mpe.mpg.de>
	<200702131034.22639.fink@mpe.mpg.de>
	<20070213112527.59eaa504@localhost.localdomain>
	<200702131332.34899.fink@mpe.mpg.de>
	<20070213144702.GD8670@thunk.org>
X-Mailer: Claws Mail 2.7.1 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> data actually did make it to the media, I wouldn't necessary assume
> that it has.  Given that it sounds like you really care about this,
> I'd suggest that you explicitly testing this before making
> assumptions.

FreeBSD 6.1 appears to get it right for some subsets of devices so it
seems a reasonable assumption at first glance - I did actually look the
BSD bits up to check.
