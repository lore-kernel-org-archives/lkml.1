Return-Path: <linux-kernel-owner+w=401wt.eu-S1758030AbXFVVCf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758030AbXFVVCf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 17:02:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751491AbXFVVC0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 17:02:26 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:2930 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751458AbXFVVCZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 17:02:25 -0400
Date: Fri, 22 Jun 2007 21:02:15 +0000
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: [RC][PATCH] PM: Remove code duplication between main.c and user.c
Message-ID: <20070622210215.GA4242@ucw.cz>
References: <200706221650.56791.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200706221650.56791.rjw@sisk.pl>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> From: Rafael J. Wysocki <rjw@sisk.pl>
> 
> The SNAPSHOT_S2RAM ioctl code is outdated and it should not duplicate the
> suspend code in kernel/power/main.c.  Fix that.
> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> Reviewed-by: Pavel Machek <pavel@ucw.cz>

ACK.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
