Return-Path: <linux-kernel-owner+w=401wt.eu-S1755194AbXIRIvT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755194AbXIRIvT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 04:51:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754560AbXIRIvI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 04:51:08 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:39845 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750968AbXIRIvH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 04:51:07 -0400
Date: Tue, 18 Sep 2007 10:51:06 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH -mm 5/5] Hibernation: Introduce exportable suspend ioctls header (rev. 2)
Message-ID: <20070918085106.GC27108@atrey.karlin.mff.cuni.cz>
References: <200709092257.16085.rjw@sisk.pl> <200709092318.51374.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200709092318.51374.rjw@sisk.pl>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Rafael J. Wysocki <rjw@sisk.pl>
> 
> Move the definitions of hibernation ioctls to a separate header file in
> include/linux, which can be exported to the user space.
> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>

ACK.
								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
