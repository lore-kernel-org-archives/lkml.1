Return-Path: <linux-kernel-owner+w=401wt.eu-S1760691AbYCCD2S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760691AbYCCD2S (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2008 22:28:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756559AbYCCD17
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Mar 2008 22:27:59 -0500
Received: from mail.gmx.net ([213.165.64.20]:40402 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752456AbYCCD17 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2008 22:27:59 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18QrvEfAE8QHjfAdeChVjfRFfXICqCxT67UJRvb0+
	QwMiIvungZvSYb
Subject: Re: [PATCH] block: fix residual byte count handling
From: Mike Galbraith <efault@gmx.de>
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: Jens Axboe <jens.axboe@oracle.com>, Mike Galbraith <efault@gmx.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org,
       linux-scsi@vger.kernel.org, Jeff Garzik <jgarzik@pobox.com>
In-Reply-To: <47CAF614.5050206@cs.wisc.edu>
References: <1204303656.4003.19.camel@localhost.localdomain>
	 <20080229201123.GK6704@kernel.dk>	<47C8F4FC.1040505@gmail.com>
	 <20080302235223X.tomof@acm.org>  <47CAF614.5050206@cs.wisc.edu>
Content-Type: text/plain
Date: Mon, 03 Mar 2008 04:27:55 +0100
Message-Id: <1204514875.4295.24.camel@homer.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Is it possible to teach Thunderturd to NOT munge the cc line?  It
stripped names from cc addresses, and here when that happens the message
lands (intentionally) in my spam grinder.  I just happened to see this
one before flushing, but now, thanks to Thunderturd, every follow-up
will also land there.  (well, not any more since I restored it)

	-Mike

