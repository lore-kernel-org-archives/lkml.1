Return-Path: <linux-kernel-owner+w=401wt.eu-S1757416AbXK0AMP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757416AbXK0AMP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 19:12:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755808AbXK0AMA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 19:12:00 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:41525 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754916AbXK0AL7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 19:11:59 -0500
Date: Tue, 27 Nov 2007 01:12:33 +0100
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/6] Suspend: Fix compilation warning for
	CONFIG_SUSPEND unset
Message-ID: <20071127001233.GA9759@elf.ucw.cz>
References: <200711270025.08128.rjw@sisk.pl> <200711270027.24230.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200711270027.24230.rjw@sisk.pl>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2007-11-27 00:27:23, Rafael J. Wysocki wrote:
> Suspend: Make debug facility depend on CONFIG_SUSPEND
> 
> Make the new suspend debug facility code depend on CONFIG_SUSPEND,
> as appropriate, to remove the compiler warning printed when CONFIG_PM is set
> and CONFIG_SUSPEND is not set.
> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>

ACK.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
