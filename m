Return-Path: <linux-kernel-owner+w=401wt.eu-S938460AbXHICzq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938460AbXHICzq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 22:55:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764744AbXHICzg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 22:55:36 -0400
Received: from emerald.lightlink.com ([205.232.34.14]:9390 "EHLO
	emerald.lightlink.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763792AbXHICzf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 22:55:35 -0400
Date: Wed, 8 Aug 2007 22:52:23 -0400
From: "Mark M. Hoffman" <mhoffman@lightlink.com>
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org, Greg KH <gregkh@suse.de>,
       Jeff Garzik <jeff@garzik.org>, Tony Luck <tony.luck@intel.com>,
       Jiri Slaby <jirislaby@gmail.com>, Roland Dreier <rolandd@cisco.com>,
       David Brownell <dbrownell@users.sourceforge.net>,
       James Smart <james.smart@emulex.com>, Hansjoerg Lipp <hjlipp@web.de>,
       Jean Delvare <khali@linux-fr.org>,
       Jeremy Fitzhardinge <jeremy@xensource.com>
Subject: Re: [PATCH] Add missing newlines to some uses of dev_<level> messages
Message-ID: <20070809025223.GD3584@jupiter.solarsys.private>
References: <1186535381.11897.29.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1186535381.11897.29.camel@localhost>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Joe Perches <joe@perches.com> [2007-08-07 18:09:39 -0700]:
> Found these while looking at printk uses.
> 
> Add missing newlines to dev_<level> uses
> Add missing KERN_<level> prefixes to multiline dev_<level>s
> Fixed a wierd->weird spelling typo
> Added a newline to a printk
> 
> Signed-off-by:  Joe Perches <joe@perches.com>

Looks good.

>  drivers/hwmon/adm1026.c                |    2 +-
>  drivers/hwmon/lm63.c                   |    2 +-
>  drivers/hwmon/vt1211.c                 |    2 +-
>  drivers/hwmon/w83791d.c                |    2 +-
>  drivers/hwmon/w83792d.c                |    4 +-

Acked-by: Mark M. Hoffman <mhoffman@lightlink.com>

Regards,

-- 
Mark M. Hoffman
mhoffman@lightlink.com

