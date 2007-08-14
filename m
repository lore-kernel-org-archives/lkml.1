Return-Path: <linux-kernel-owner+w=401wt.eu-S932561AbXHNR6K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932561AbXHNR6K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 13:58:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755668AbXHNR5y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 13:57:54 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:4733 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755459AbXHNR5x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 13:57:53 -0400
Subject: Re: [PATCH] [443/2many] MAINTAINERS - HIBERNATION (aka Software
	Suspend, aka swsusp):
From: Joe Perches <joe@perches.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Pavel Machek <pavel@ucw.cz>, torvalds@linux-foundation.org,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
In-Reply-To: <200708141937.06676.rjw@sisk.pl>
References: <46bffbd3.IqsNHrHU1Y9BF7Dd%joe@perches.com>
	 <200708132338.25925.rjw@sisk.pl> <20070814070528.GA2903@elf.ucw.cz>
	 <200708141937.06676.rjw@sisk.pl>
Content-Type: text/plain
Date: Tue, 14 Aug 2007 10:57:10 -0700
Message-Id: <1187114231.32555.105.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2-2.1mdv2007.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-08-14 at 19:37 +0200, Rafael J. Wysocki wrote:
> (1) hibernation
> F:      Documentation/power/
> F:      arch/i386/power/
> F:      arch/x86_64/kernel/suspend_asm.S
> F:      arch/x86_64/kernel/suspend.c
> F:      drivers/base/power/
> F:      kernel/power/
> F:      include/linux/suspend.h
> F:      include/linux/freezer.h
> F:      include/linux/pm.h
> F:      include/asm-*/suspend.h
> 
> (2) suspend
> F:      Documentation/power/
> F:      arch/i386/kernel/acpi/
> F:      arch/x86_64/kernel/acpi/
> F:      arch/x86_64/kernel/suspend.c
> F:      drivers/base/power/
> F:      kernel/power/
> F:      include/linux/suspend.h
> F:      include/linux/freezer.h
> F:      include/linux/pm.h
> F:      include/asm-*/suspend.h

SUSPEND TO RAM:
P:	Pavel Machek
M:	pavel@suse.cz
P:	Rafael J. Wysocki
M:	rjw@sisk.pl
L:	linux-pm@lists.linux-foundation.org
S:	Maintained
F:	Documentation/power/
F:	arch/i386/kernel/acpi/
F:	arch/x86_64/kernel/acpi/
F:	arch/x86_64/kernel/suspend.c
F:	drivers/base/power/
F:	kernel/power/
F:	include/linux/suspend.h
F:	include/linux/freezer.h
F:	include/linux/pm.h
F:	include/asm-*/suspend.h

HIBERNATION (aka Software Suspend, aka swsusp)
P:	Pavel Machek
M:	pavel@suse.cz
P:	Rafael J. Wysocki
M:	rjw@sisk.pl
L:	linux-pm@lists.linux-foundation.org
S:	Supported
F:	Documentation/power/
F:	arch/i386/power/
F:	arch/x86_64/kernel/suspend_asm.S
F:	arch/x86_64/kernel/suspend.c
F:	drivers/base/power/
F:	kernel/power/
F:	include/linux/suspend.h
F:	include/linux/freezer.h
F:	include/linux/pm.h
F:	include/asm-*/suspend.h


