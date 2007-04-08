Return-Path: <linux-kernel-owner+w=401wt.eu-S1750992AbXDHMLI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750992AbXDHMLI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Apr 2007 08:11:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751023AbXDHMLI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Apr 2007 08:11:08 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:3125 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750992AbXDHMLH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Apr 2007 08:11:07 -0400
Date: Sun, 8 Apr 2007 12:10:58 +0000
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Gautham R Shenoy <ego@in.ibm.com>, LKML <linux-kernel@vger.kernel.org>,
       Nigel Cunningham <ncunningham@linuxmail.org>
Subject: Re: [PATCH -mm] freezer: Remove PF_NOFREEZE from handle_initrd
Message-ID: <20070408121058.GA4310@ucw.cz>
References: <200704071814.25588.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200704071814.25588.rjw@sisk.pl>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> From: Rafael J. Wysocki <rjw@sisk.pl>
> 
> Make handle_initrd() call try_to_freeze() in a suitable place instead of setting
> PF_NOFREEZE for the current task.

ACK and thanks.

							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
