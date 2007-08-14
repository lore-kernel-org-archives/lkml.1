Return-Path: <linux-kernel-owner+w=401wt.eu-S1759473AbXHNXzX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759473AbXHNXzX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 19:55:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752078AbXHNXzA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 19:55:00 -0400
Received: from styx.suse.cz ([82.119.242.94]:48818 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754073AbXHNXy7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 19:54:59 -0400
Date: Wed, 15 Aug 2007 01:51:09 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: joe@perches.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [217/2many] MAINTAINERS - HID CORE LAYER
In-Reply-To: <46bffa13.u2UP+i4L1tdJi0Sf%joe@perches.com>
Message-ID: <Pine.LNX.4.64.0708150148190.29843@jikos.suse.cz>
References: <46bffa13.u2UP+i4L1tdJi0Sf%joe@perches.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 12 Aug 2007, joe@perches.com wrote:

> Add file pattern to MAINTAINER entry
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index bdbf999..4a8770c 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -2071,6 +2071,8 @@ M:	jkosina@suse.cz
>  L:	linux-input@atrey.karlin.mff.cuni.cz
>  T:	git kernel.org:/pub/scm/linux/kernel/git/jikos/hid.git
>  S:	Maintained
> +F:	drivers/hid/
> +F:	include/linux/hid*
>  
>  HIGH-RESOLUTION TIMERS, CLOCKEVENTS, DYNTICKS
>  P:	Thomas Gleixner
> 

If this is ever going to be merged, you can add

	Signed-off-by: Jiri Kosina <jkosina@suse.cz>

-- 
Jiri Kosina
SUSE Labs
