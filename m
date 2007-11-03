Return-Path: <linux-kernel-owner+w=401wt.eu-S1757587AbXKCSWJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757587AbXKCSWJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2007 14:22:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755283AbXKCSV7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Nov 2007 14:21:59 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:54202 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755170AbXKCSV7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2007 14:21:59 -0400
Date: Sat, 3 Nov 2007 19:22:06 +0100
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Len Brown <lenb@kernel.org>, Alan Stern <stern@rowland.harvard.edu>,
       LKML <linux-kernel@vger.kernel.org>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: [PATCH] Hibernation: Add PM_RESTORE_PREPARE and
	PM_POST_RESTORE notifiers
Message-ID: <20071103182206.GB13202@elf.ucw.cz>
References: <200711012347.44662.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200711012347.44662.rjw@sisk.pl>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2007-11-01 23:47:43, Rafael J. Wysocki wrote:
> [Len, please add to the suspend branch.]
> ---
> From: Alan Stern <stern@rowland.harvard.edu>
> 
> This patch (as1006) adds PM_RESTORE_PREPARE and PM_POST_RESTORE
> notifiers to the PM core, to be used in analogy with the existing
> PM_HIBERNATION_PREPARE and PM_POST_HIBERNATION notifiers.
> 
> Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
> Cc: Pavel Machek <pavel@ucw.cz>
> Cc: Nigel Cunningham <nigel@nigel.suspend2.net>
> Signed-off-by: "Rafael J. Wysocki" <rjw@sisk.pl>

ACK.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
