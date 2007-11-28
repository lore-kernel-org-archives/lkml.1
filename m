Return-Path: <linux-kernel-owner+w=401wt.eu-S1759603AbXK1KOc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759603AbXK1KOc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 05:14:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756649AbXK1KOW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 05:14:22 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:56811 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755781AbXK1KOW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 05:14:22 -0500
Date: Wed, 28 Nov 2007 11:14:55 +0100
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 7/7] Hibernation: Update messages
Message-ID: <20071128101455.GD1957@elf.ucw.cz>
References: <200711280113.36941.rjw@sisk.pl> <200711280137.25481.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200711280137.25481.rjw@sisk.pl>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> Make hibernation messages start with one common prefix "PM: " and use
> the word "hibernation" in messages as a synonym of "suspend to disk".
> 
> Turn some KERN_INFO messages into debug ones.
> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>

ACK. Whole series looks good.

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
