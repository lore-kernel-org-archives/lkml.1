Return-Path: <linux-kernel-owner+w=401wt.eu-S1753503Ab0AXXlm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753503Ab0AXXlm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jan 2010 18:41:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751959Ab0AXXlT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jan 2010 18:41:19 -0500
Received: from ip-85-161-27-212.eurotel.cz ([85.161.27.212]:34002 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751669Ab0AXXlS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jan 2010 18:41:18 -0500
Date: Wed, 20 Jan 2010 13:55:55 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Mark Allyn <mark.a.allyn@intel.com>
Cc: linux-kernel@vger.kernel.org, greg@kroah.com, alan@linux.intel.com,
       charles.f.johnson@intel.com
Subject: Re: [PATCH] Add Linux Driver for Intel Langwell Watchdog
Message-ID: <20100120125555.GD1420@ucw.cz>
References: <1263849859-23265-1-git-send-email-mark.a.allyn@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1263849859-23265-1-git-send-email-mark.a.allyn@intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +++ b/drivers/watchdog/Kconfig
> @@ -448,6 +448,13 @@ config IBMASR
>  	  To compile this driver as a module, choose M here: the
>  	  module will be called ibmasr.
>  
> +config LANGWELL_WATCHDOG
> +	tristate "Intel Langwell Watchdog for Mobil Platforms"

typo?

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
