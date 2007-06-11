Return-Path: <linux-kernel-owner+w=401wt.eu-S1755497AbXFKVjl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755497AbXFKVjl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 17:39:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752780AbXFKVje
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 17:39:34 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:57118 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750930AbXFKVjd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 17:39:33 -0400
Date: Mon, 11 Jun 2007 23:39:24 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: pm list <linux-pm@lists.linux-foundation.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       David Brownell <david-b@pacbell.net>, Greg KH <greg@kroah.com>,
       LKML <linux-kernel@vger.kernel.org>,
       USB development list <linux-usb-devel@lists.sourceforge.net>
Subject: Re: [RFC][PATCH -mm 3/7] PM: Simplify suspend_device
Message-ID: <20070611213924.GD3917@elf.ucw.cz>
References: <200706111655.50022.rjw@sisk.pl> <200706111701.58648.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200706111701.58648.rjw@sisk.pl>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> From: Rafael J. Wysocki <rjw@sisk.pl>
> 
> Reduce code duplication in drivers/base/suspend.c by introducing a separate
> function for printing diagnostic messages.
> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>

ACK, thanks.
							Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
