Return-Path: <linux-kernel-owner+w=401wt.eu-S1757944AbXFNWQ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757944AbXFNWQ1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 18:16:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757410AbXFNWOA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 18:14:00 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:53044 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751751AbXFNWN6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 18:13:58 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Frank Seidel <fseidel@suse.de>, Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH, 3rd try] make disable_console_suspend runtime configurable
Date: Fri, 15 Jun 2007 00:20:28 +0200
User-Agent: KMail/1.9.5
Cc: Stefan Seyfried <seife@suse.de>, linux-kernel@vger.kernel.org,
       suspend-devel List <suspend-devel@lists.sourceforge.net>,
       akpm@linux-foundation.org, nigel@nigel.suspend2.net
References: <20070613200303.GB11437@suse.de> <200706141414.22152.rjw@sisk.pl> <200706141559.54242.fseidel@suse.de>
In-Reply-To: <200706141559.54242.fseidel@suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706150020.29189.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 14 June 2007 15:59, Frank Seidel wrote:
> From: Stefan Seyfried <seife@suse.de>
> 
> I hate having to recompile the kernel, just to be able to debug suspend.
> Remove CONFIG_DISABLE_CONSOLE_SUSPEND, replace it by a tunable in
> /sys/power/disable_console_suspend.
> 
> 
> Signed-off-by: Stefan Seyfried <seife@suse.de>
> Signed-off-by: Frank Seidel <fseidel@suse.de>
> ---
> Third try, renamed sysfs interface to console_suspend 
> reporting and expecting either "enabled" or "disabled"

Thanks a lot for redoing it.

I have no objections.  Pavel?

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth
