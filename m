Return-Path: <linux-kernel-owner+w=401wt.eu-S1757254AbYKJABa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757254AbYKJABa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2008 19:01:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756516AbYKJABV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Nov 2008 19:01:21 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:45586 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756308AbYKJABU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2008 19:01:20 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Miquel van Smoorenburg <mikevs@xs4all.net>
Subject: Re: [Bug #11830] disk statistics issue in 2.6.27
Date: Mon, 10 Nov 2008 01:05:53 +0100
User-Agent: KMail/1.9.9
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       James Bottomley <James.Bottomley@hansenpartnership.com>,
       Jens Axboe <jens.axboe@oracle.com>
References: <A3oCZU7cpuO.A.ChB.ZZ1FJB@chimera> <4B0Eqx89uNG.A.-PC.tZ1FJB@chimera> <1226274573.6979.1.camel@localhost.localdomain>
In-Reply-To: <1226274573.6979.1.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811100105.53862.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 10 of November 2008, Miquel van Smoorenburg wrote:
> On Sun, 2008-11-09 at 20:43 +0100, Rafael J. Wysocki wrote:
> > This message has been generated automatically as a part of a report
> > of regressions introduced between 2.6.26 and 2.6.27.
> > 
> > The following bug entry is on the current list of known regressions
> > introduced between 2.6.26 and 2.6.27.  Please verify if it still should
> > be listed and let me know (either way).
> 
> The cause has been found - a bug in the dpt_i2o driver that was hidden
> until 2.6.27.
> 
> I've submitted a patch for 2.6.28 which will be included in the next
> -rc, at which point I will submit it for 2.6.27-stable as well.

Thanks for the info.

Can you please put a pointer to the patch into the Bugzilla entry?

Rafael
