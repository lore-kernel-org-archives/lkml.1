Return-Path: <linux-kernel-owner+w=401wt.eu-S1761740AbXE1NEy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761740AbXE1NEy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 09:04:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753421AbXE1NEr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 09:04:47 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:43327 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753411AbXE1NEq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 09:04:46 -0400
Date: Mon, 28 May 2007 15:04:41 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Alan Stern <stern@rowland.harvard.edu>,
       Oliver Neukum <oliver@neukum.org>
Subject: Re: [RFC][PATCH -mm 2/3] PM: Disable usermode helper before hibernation/suspend
Message-ID: <20070528130441.GM18807@elf.ucw.cz>
References: <200705272229.21263.rjw@sisk.pl> <200705272230.56863.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200705272230.56863.rjw@sisk.pl>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> Use a hibernation and suspend notifier to disable the user mode helper before
> a hibernation/suspend and enable it after the operation.

Seems ok to me.
								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
