Return-Path: <linux-kernel-owner+w=401wt.eu-S1764137AbXGKNOJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764137AbXGKNOJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 09:14:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761975AbXGKNNz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 09:13:55 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:1592 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759096AbXGKNNy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 09:13:54 -0400
Date: Mon, 9 Jul 2007 13:29:05 +0000
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org,
       Alan Stern <stern@rowland.harvard.edu>
Subject: sysrq-t dumps of s2ram/fuse deadlock (was Re: [PATCH] Remove process freezer from suspend to RAM pathway)
Message-ID: <20070709132905.GA5212@ucw.cz>
References: <20070703042916.GA17240@srcf.ucam.org> <200707031456.36027.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200707031456.36027.rjw@sisk.pl>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

Can we get them? They are neccessary for debugging 'what in suspend
calls fuse' problem. And yes, that problem is there even when you
remove freezer.

Matthew, you seem to be the only one able to produce them...
							Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
