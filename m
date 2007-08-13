Return-Path: <linux-kernel-owner+w=401wt.eu-S967048AbXHMUni@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967048AbXHMUni (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 16:43:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764735AbXHMUnE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 16:43:04 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:37623 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759971AbXHMUnB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 16:43:01 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: joe@perches.com
Subject: Re: [PATCH] [444/2many] MAINTAINERS - SUSPEND TO RAM:
Date: Mon, 13 Aug 2007 22:52:54 +0200
User-Agent: KMail/1.9.5
Cc: torvalds@linux-foundation.org, pavel@suse.cz,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
References: <46bffbd5.kKrnXsYdLyNKojxF%joe@perches.com>
In-Reply-To: <46bffbd5.kKrnXsYdLyNKojxF%joe@perches.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708132252.55738.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 13 August 2007 08:36, joe@perches.com wrote:
> Add file pattern to MAINTAINER entry
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 5ae90a2..e9e7a00 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -4226,6 +4226,7 @@ P:	Rafael J. Wysocki
>  M:	rjw@sisk.pl
>  L:	linux-pm@lists.linux-foundation.org
>  S:	Maintained
> +F:	kernel/power/

+F:	drivers/base/power
+F:	arch/x86_64/kernel/acpi
+F:	arch/i386/kernel/acpi/

>  
>  SONIC NETWORK DRIVER
>  P:	Thomas Bogendoerfer
> 
> 

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth
