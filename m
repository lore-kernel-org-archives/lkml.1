Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752092Ab0CBGFT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 01:05:19 -0500
Received: from ksp.mff.cuni.cz ([195.113.26.206]:49792 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751419Ab0CBGFR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 01:05:17 -0500
Date: Tue, 2 Mar 2010 07:05:07 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: greg@kroah.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 26/26] w35und: Update README
Message-ID: <20100302060506.GA1503@ucw.cz>
References: <1267455868-4533-1-git-send-email-penberg@cs.helsinki.fi> <1267455868-4533-26-git-send-email-penberg@cs.helsinki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1267455868-4533-26-git-send-email-penberg@cs.helsinki.fi>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2010-03-01 17:04:28, Pekka Enberg wrote:
> Typedefs are gone now so update the README file.

All but one that makes sense :-). Yep, ACK for whole series. And
thanks for your work.
							Pavel

> --- a/drivers/staging/winbond/README
> +++ b/drivers/staging/winbond/README
> @@ -2,7 +2,6 @@ TODO:
>  	- sparse cleanups
>  	- checkpatch cleanups
>  	- kerneldoc cleanups
> -	- remove typedefs
>  	- remove unused ioctls
>  	- use cfg80211 for regulatory stuff
>  	- fix 4k stack problems

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
