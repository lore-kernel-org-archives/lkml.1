Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756666Ab0CNJrO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Mar 2010 05:47:14 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:51998 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755261Ab0CNJrI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Mar 2010 05:47:08 -0400
Message-ID: <4B9CB091.1040108@cs.helsinki.fi>
Date: Sun, 14 Mar 2010 11:46:57 +0200
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.23 (Macintosh/20090812)
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Lars Lindley <lindley@coyote.org>, gregkh@suse.de, diegoliz@gmail.com,
       devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [patch] staging/winbond: camelCase should be fixed
References: <1268430337-18192-1-git-send-email-lindley@coyote.org> <20100313063109.GB12554@elf.ucw.cz> <4B9B6409.3070502@coyote.org> <4B9B6ADC.6060204@s5r6.in-berlin.de> <20100313112005.GB2192@elf.ucw.cz>
In-Reply-To: <20100313112005.GB2192@elf.ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
>> (BTW, winbond/README alias winbond/TODO doesn't mention it, but another
>> (trivial) step is going to be to change variable names and function
>> names from CamelCase to lower_case spelling.)
> 
> Yes.
> 
> Signed-off-by: Pavel Machek <pavel@ucw.cz>

Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>

> diff --git a/drivers/staging/winbond/README b/drivers/staging/winbond/README
> index cb944e4..2771024 100644
> --- a/drivers/staging/winbond/README
> +++ b/drivers/staging/winbond/README
> @@ -2,6 +2,7 @@ TODO:
>  	- sparse cleanups
>  	- checkpatch cleanups
>  	- kerneldoc cleanups
> +	- fix severeCamelCaseInfestation
>  	- remove typedefs
>  	- remove unused ioctls
>  	- use cfg80211 for regulatory stuff
> 
> 

