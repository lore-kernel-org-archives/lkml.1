Return-Path: <linux-kernel-owner+w=401wt.eu-S1754399Ab0A0TsT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754399Ab0A0TsT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 14:48:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754150Ab0A0TsS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 14:48:18 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:34960 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751202Ab0A0TsS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 14:48:18 -0500
Date: Wed, 27 Jan 2010 20:48:11 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Jiri Slaby <jslaby@suse.cz>
Cc: rjw@sisk.pl, linux-pm@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] PM: really deprecate deprecated user ioctls
Message-ID: <20100127194811.GB4626@elf.ucw.cz>
References: <1264610778-13242-1-git-send-email-jslaby@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1264610778-13242-1-git-send-email-jslaby@suse.cz>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2010-01-27 17:46:17, Jiri Slaby wrote:
> They were deprecated and removed from exported headers more than 2
> years ago. Inform users about their removal in the future now.
> 
> (Switch cases needed to be reorderded for an easy fall through.)
> 
> And add an entry to feature-removal-schedule.
> 
> Signed-off-by: Jiri Slaby <jslaby@suse.cz>
> Cc: Rafael J. Wysocki <rjw@sisk.pl>
> Cc: Pavel Machek <pavel@ucw.cz>

ACK.
								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
