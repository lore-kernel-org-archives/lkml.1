Return-Path: <linux-kernel-owner+w=401wt.eu-S1758356AbXFMW4F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758356AbXFMW4F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 18:56:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755266AbXFMWzy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 18:55:54 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:48609 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754589AbXFMWzx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 18:55:53 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Greg KH <greg@kroah.com>
Subject: Re: [PATCH -mm 0/7] PM: Remove unused and unnecessary features from suspend and resume core
Date: Thu, 14 Jun 2007 01:02:31 +0200
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       David Brownell <david-b@pacbell.net>,
       LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>
References: <200706131551.51336.rjw@sisk.pl> <20070613215946.GA26206@kroah.com>
In-Reply-To: <20070613215946.GA26206@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706140102.31871.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 13 June 2007 23:59, Greg KH wrote:
> On Wed, Jun 13, 2007 at 03:51:48PM +0200, Rafael J. Wysocki wrote:
> > Hi,
> > 
> > The following series of patches removes some unused and unnecessary features
> > from the suspend and resume core code.
> 
> These are the same as you sent out the other day, right?

Almost.

The "PM: Remove pm_parent from struct dev_pm_info" (1/7) has been updated.

The "PM: Remove prev_state from struct dev_pm_info" patch (5/7) has been
rediffed against 2.6.22-rc4-mm2 (to synchronize with the USB changes in there).

The others are the same.

> If so, I'll put them in my tree, trying to catch up on my queue right
> now.

OK

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth
