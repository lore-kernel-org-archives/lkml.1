Return-Path: <linux-kernel-owner+w=401wt.eu-S1756624AbXFCQmj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756624AbXFCQmj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2007 12:42:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753487AbXFCQmc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jun 2007 12:42:32 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:4106 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753426AbXFCQmb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2007 12:42:31 -0400
Date: Sun, 3 Jun 2007 16:42:19 +0000
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Alan Stern <stern@rowland.harvard.edu>,
       Oliver Neukum <oliver@neukum.org>
Subject: Re: [RFC][PATCH -mm 2/2] PM: Disable usermode helper before hibernation and suspend
Message-ID: <20070603164219.GC4093@ucw.cz>
References: <200705272229.21263.rjw@sisk.pl> <200706020241.53788.rjw@sisk.pl> <200706020244.50180.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200706020244.50180.rjw@sisk.pl>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> From: Rafael J. Wysocki <rjw@sisk.pl>
> 
> Use a hibernation and suspend notifier to disable the user mode helper before
> a hibernation/suspend and enable it after the operation.
> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>

ACK.
							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
