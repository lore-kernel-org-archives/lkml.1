Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753210Ab0CMGah (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Mar 2010 01:30:37 -0500
Received: from ksp.mff.cuni.cz ([195.113.26.206]:52589 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752592Ab0CMGaf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Mar 2010 01:30:35 -0500
Date: Sat, 13 Mar 2010 07:30:28 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Lars Lindley <lindley@coyote.org>
Cc: gregkh@suse.de, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: winbond: Renamed README to TODO and corrected
 Pavel's mail
Message-ID: <20100313063028.GA12554@elf.ucw.cz>
References: <1268431099-18367-1-git-send-email-lindley@coyote.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1268431099-18367-1-git-send-email-lindley@coyote.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> diff --git a/drivers/staging/winbond/README b/drivers/staging/winbond/README
> deleted file mode 100644
> index cb944e4..0000000
> --- a/drivers/staging/winbond/README
> +++ /dev/null
> @@ -1,11 +0,0 @@
> -TODO:
> -	- sparse cleanups
> -	- checkpatch cleanups
> -	- kerneldoc cleanups
> -	- remove typedefs
> -	- remove unused ioctls
> -	- use cfg80211 for regulatory stuff
> -	- fix 4k stack problems
> -
> -Please send patches to Greg Kroah-Hartman <greg@kroah.com> and
> -Pavel Machek <pavel@suse.cz>
> diff --git a/drivers/staging/winbond/TODO b/drivers/staging/winbond/TODO
> new file mode 100644
> index 0000000..f4fb3f3
> --- /dev/null
> +++ b/drivers/staging/winbond/TODO
> @@ -0,0 +1,11 @@
> +TODO:
> +	- sparse cleanups
> +	- checkpatch cleanups
> +	- kerneldoc cleanups
> +	- remove typedefs
> +	- remove unused ioctls
> +	- use cfg80211 for regulatory stuff
> +	- fix 4k stack problems
> +
> +Please send patches to Greg Kroah-Hartman <greg@kroah.com> and
> +Pavel Machek <pavel@ucw.cz>

ACK.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
