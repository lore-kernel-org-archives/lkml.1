Return-Path: <linux-kernel-owner+w=401wt.eu-S1754753AbXIRIu6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754753AbXIRIu6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 04:50:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752368AbXIRIuv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 04:50:51 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:39796 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750968AbXIRIuu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 04:50:50 -0400
Date: Tue, 18 Sep 2007 10:50:49 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH -mm 4/5] Hibernation: Correct definitions of some ioctls (rev. 2)
Message-ID: <20070918085049.GB27108@atrey.karlin.mff.cuni.cz>
References: <200709092257.16085.rjw@sisk.pl> <200709092312.52889.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200709092312.52889.rjw@sisk.pl>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Rafael J. Wysocki <rjw@sisk.pl>
> 
> Three ioctl numbers belonging to the hibernation userland interface,
> SNAPSHOT_ATOMIC_SNAPSHOT, SNAPSHOT_SET_IMAGE_SIZE, SNAPSHOT_AVAIL_SWAP,
> SNAPSHOT_GET_SWAP_PAGE, are defined in a wrong way (eg. not portable).  Provide
> new ioctl numbers for these ioctls and mark the existing ones as deprecated.
> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>

ACK.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
