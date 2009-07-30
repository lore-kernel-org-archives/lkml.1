Return-Path: <linux-kernel-owner+w=401wt.eu-S1752243AbZG3JpE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752243AbZG3JpE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 05:45:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752051AbZG3JpD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 05:45:03 -0400
Received: from mail.gmx.net ([213.165.64.20]:55518 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751589AbZG3JpC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 05:45:02 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19nV897K81nH9t7x/woyej0TWOE1PZPateDdyoYyB
	b5X3j/QRZ80+rH
Subject: Re: [wireless] rt2870sta BUGs on shutdown,
 2.6.30.2->git.today+git.wireless.today
From: Mike Galbraith <efault@gmx.de>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       "John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <1248946195.8925.9.camel@johannes.local>
References: <1248945770.7910.24.camel@marge.simson.net>
	 <1248946195.8925.9.camel@johannes.local>
Content-Type: text/plain
Date: Thu, 30 Jul 2009 11:44:59 +0200
Message-Id: <1248947099.8396.6.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-07-30 at 11:29 +0200, Johannes Berg wrote:
> On Thu, 2009-07-30 at 11:22 +0200, Mike Galbraith wrote:
> 
> > drivers/staging/rt2870/../rt2860/sta_ioctl.c
> 
> Sorry, but that '/staging/' thing in there means we cannot support this.
> If you must, take your query to the staging list,
> devel@driverdev.osuosl.org (according to MAINTAINERS).

Forwarded, thanks.

....hm.  Does "If you must" mean reports aren't welcome?

	-Mike

