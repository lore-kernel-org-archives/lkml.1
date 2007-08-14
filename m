Return-Path: <linux-kernel-owner+w=401wt.eu-S1765099AbXHNXzs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765099AbXHNXzs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 19:55:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754917AbXHNXzD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 19:55:03 -0400
Received: from styx.suse.cz ([82.119.242.94]:48875 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754073AbXHNXzA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 19:55:00 -0400
Date: Wed, 15 Aug 2007 01:52:08 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: joe@perches.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [496/2many] MAINTAINERS - USB HID/HIDBP DRIVERS (USB
 KEYBOARDS, MICE, REMOTE CONTROLS, ...)
In-Reply-To: <46bffc55.PFZbCJDLM7vdarZe%joe@perches.com>
Message-ID: <Pine.LNX.4.64.0708150151210.29843@jikos.suse.cz>
References: <46bffc55.PFZbCJDLM7vdarZe%joe@perches.com>
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
> index ae24def..270952c 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -4696,6 +4696,8 @@ M:	jkosina@suse.cz
>  L:	linux-usb-devel@lists.sourceforge.net
>  T:	git kernel.org:/pub/scm/linux/kernel/git/jikos/hid.git
>  S:	Maintained
> +F:	Documentation/usb/hiddev.txt
> +F:	drivers/hid/usbhid/
>  
>  USB HUB DRIVER
>  P:	Johannes Erdfelt

Same here -- if this goes upstream, you can add

	Signed-off-by: Jiri Kosina <jkosina@suse.cz>

Thanks,

-- 
Jiri Kosina
SUSE Labs
