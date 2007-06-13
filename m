Return-Path: <linux-kernel-owner+w=401wt.eu-S1758094AbXFMVbV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758094AbXFMVbV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 17:31:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754908AbXFMV3m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 17:29:42 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:48335 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754034AbXFMV3k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 17:29:40 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Stefan Seyfried <seife@suse.de>
Subject: Re: [PATCH, 2nd try] make disable_console_suspend runtime configurable
Date: Wed, 13 Jun 2007 23:36:07 +0200
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org,
       suspend-devel List <suspend-devel@lists.sourceforge.net>,
       Frank Seidel <fseidel@suse.de>, akpm@linux-foundation.org,
       nigel@nigel.suspend2.net, pavel@ucw.cz
References: <20070613200303.GB11437@suse.de>
In-Reply-To: <20070613200303.GB11437@suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706132336.08053.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 13 June 2007 22:03, Stefan Seyfried wrote:
> I hate having to recompile the kernel, just to be able to debug suspend.
> Remove CONFIG_DISABLE_CONSOLE_SUSPEND, replace it by a tunable in
> /sys/power/disable_console_suspend.
> 
> Signed-off-by: Stefan Seyfried <seife@suse.de>
> Signed-off-by: Frank Seidel <fseidel@suse.de>
> ---
> Second try, no longer uses a sysctl in /proc, but a tunable in /sys/power.
> Thanks Frank for moving it quicker to sysfs than i would have ever been
> able to :-)

ACK

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth
