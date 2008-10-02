Return-Path: <linux-kernel-owner+w=401wt.eu-S1754154AbYJBJIb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754154AbYJBJIb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 05:08:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753192AbYJBJIX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 05:08:23 -0400
Received: from ik-out-1112.google.com ([66.249.90.179]:58332 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753122AbYJBJIX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 05:08:23 -0400
Message-ID: <f488382f0810020208u5761a84p5cac040503f55917@mail.gmail.com>
Date: Thu, 2 Oct 2008 02:08:20 -0700
From: "Steven Noonan" <steven@uplinklabs.net>
To: "Pavel Machek" <pavel@suse.cz>
Subject: Re: make MAINTAINERS slightly easier to search
Cc: "kernel list" <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@osdl.org>, randy.dunlap@oracle.com
In-Reply-To: <20081002081428.GA2022@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081002081428.GA2022@elf.ucw.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 2, 2008 at 1:14 AM, Pavel Machek <pavel@suse.cz> wrote:
> ...shall we add rule that subsystems will have "subsystem" in the name
> so that search does not list all the drivers, first?
>
> Signed-off-by: Pavel Machek <pavel@suse.cz>
> Acked-by: Randy Dunlap <randy.dunlap@oracle.com>
>
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 3596d17..7345707 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -3825,7 +3825,7 @@ L:        linux-kernel@vger.kernel.org
>  W:     http://tifmxx.berlios.de/
>  S:     Maintained
>
> -SOUND
> +SOUND SUBSYSTEM (ADVANCED LINUX SOUND SYSTEM, ALSA)

Advanced Linux Sound System = ALSS? How about switching it to
'ADVANCED LINUX SOUND ARCHITECTURE', which fits the original acronym?
:)

>  P:     Jaroslav Kysela
>  M:     perex@perex.cz
>  L:     alsa-devel@alsa-project.org (subscribers-only)
> @@ -3855,7 +3855,7 @@ L:        cbe-oss-dev@ozlabs.org
>  W:     http://www.ibm.com/developerworks/power/cell/
>  S:     Supported
>
> -STABLE BRANCH:
> +STABLE BRANCH
>  P:     Greg Kroah-Hartman
>  M:     greg@kroah.com
>  P:     Chris Wright
>
