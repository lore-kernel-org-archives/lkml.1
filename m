Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759077Ab0CMLUP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Mar 2010 06:20:15 -0500
Received: from ksp.mff.cuni.cz ([195.113.26.206]:55585 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759034Ab0CMLUL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Mar 2010 06:20:11 -0500
Date: Sat, 13 Mar 2010 12:20:05 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Lars Lindley <lindley@coyote.org>, gregkh@suse.de, penberg@cs.helsinki.fi,
       diegoliz@gmail.com, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org
Subject: [patch] staging/winbond: camelCase should be fixed
Message-ID: <20100313112005.GB2192@elf.ucw.cz>
References: <1268430337-18192-1-git-send-email-lindley@coyote.org>
 <20100313063109.GB12554@elf.ucw.cz>
 <4B9B6409.3070502@coyote.org>
 <4B9B6ADC.6060204@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B9B6ADC.6060204@s5r6.in-berlin.de>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> (BTW, winbond/README alias winbond/TODO doesn't mention it, but another
> (trivial) step is going to be to change variable names and function
> names from CamelCase to lower_case spelling.)

Yes.

Signed-off-by: Pavel Machek <pavel@ucw.cz>

diff --git a/drivers/staging/winbond/README b/drivers/staging/winbond/README
index cb944e4..2771024 100644
--- a/drivers/staging/winbond/README
+++ b/drivers/staging/winbond/README
@@ -2,6 +2,7 @@ TODO:
 	- sparse cleanups
 	- checkpatch cleanups
 	- kerneldoc cleanups
+	- fix severeCamelCaseInfestation
 	- remove typedefs
 	- remove unused ioctls
 	- use cfg80211 for regulatory stuff


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
