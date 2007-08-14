Return-Path: <linux-kernel-owner+w=401wt.eu-S932804AbXHNSFF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932804AbXHNSFF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 14:05:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765702AbXHNSEn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 14:04:43 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:43342 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762923AbXHNSEm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 14:04:42 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Joe Perches <joe@perches.com>
Subject: Re: [PATCH] [443/2many] MAINTAINERS - HIBERNATION (aka Software Suspend, aka swsusp):
Date: Tue, 14 Aug 2007 20:14:38 +0200
User-Agent: KMail/1.9.5
Cc: Pavel Machek <pavel@ucw.cz>, torvalds@linux-foundation.org,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
References: <46bffbd3.IqsNHrHU1Y9BF7Dd%joe@perches.com> <200708141937.06676.rjw@sisk.pl> <1187114231.32555.105.camel@localhost>
In-Reply-To: <1187114231.32555.105.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708142014.39391.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 14 August 2007 19:57, Joe Perches wrote:
> On Tue, 2007-08-14 at 19:37 +0200, Rafael J. Wysocki wrote:
> > (1) hibernation
> > F:      Documentation/power/
> > F:      arch/i386/power/
> > F:      arch/x86_64/kernel/suspend_asm.S
> > F:      arch/x86_64/kernel/suspend.c
> > F:      drivers/base/power/
> > F:      kernel/power/
> > F:      include/linux/suspend.h
> > F:      include/linux/freezer.h
> > F:      include/linux/pm.h
> > F:      include/asm-*/suspend.h
> > 
> > (2) suspend
> > F:      Documentation/power/
> > F:      arch/i386/kernel/acpi/
> > F:      arch/x86_64/kernel/acpi/
> > F:      arch/x86_64/kernel/suspend.c
> > F:      drivers/base/power/
> > F:      kernel/power/
> > F:      include/linux/suspend.h
> > F:      include/linux/freezer.h
> > F:      include/linux/pm.h
> > F:      include/asm-*/suspend.h
> 
> SUSPEND TO RAM:
> P:	Pavel Machek
> M:	pavel@suse.cz
> P:	Rafael J. Wysocki
> M:	rjw@sisk.pl
> L:	linux-pm@lists.linux-foundation.org
> S:	Maintained
> F:	Documentation/power/
> F:	arch/i386/kernel/acpi/
> F:	arch/x86_64/kernel/acpi/
> F:	arch/x86_64/kernel/suspend.c
> F:	drivers/base/power/
> F:	kernel/power/
> F:	include/linux/suspend.h
> F:	include/linux/freezer.h
> F:	include/linux/pm.h
> F:	include/asm-*/suspend.h
> 
> HIBERNATION (aka Software Suspend, aka swsusp)
> P:	Pavel Machek
> M:	pavel@suse.cz
> P:	Rafael J. Wysocki
> M:	rjw@sisk.pl
> L:	linux-pm@lists.linux-foundation.org
> S:	Supported
> F:	Documentation/power/
> F:	arch/i386/power/
> F:	arch/x86_64/kernel/suspend_asm.S
> F:	arch/x86_64/kernel/suspend.c
> F:	drivers/base/power/
> F:	kernel/power/
> F:	include/linux/suspend.h
> F:	include/linux/freezer.h
> F:	include/linux/pm.h
> F:	include/asm-*/suspend.h

ACK
