Return-Path: <linux-kernel-owner+w=401wt.eu-S936458AbXHMVXm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936458AbXHMVXm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 17:23:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759494AbXHMVWs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 17:22:48 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:3739 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758232AbXHMVWr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 17:22:47 -0400
Subject: Re: [PATCH] [443/2many] MAINTAINERS - HIBERNATION (aka Software
	Suspend, aka swsusp):
From: Joe Perches <joe@perches.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: torvalds@linux-foundation.org, pavel@suse.cz,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
In-Reply-To: <200708132325.04810.rjw@sisk.pl>
References: <46bffbd3.IqsNHrHU1Y9BF7Dd%joe@perches.com>
	 <200708132250.15466.rjw@sisk.pl> <1187038479.10249.304.camel@localhost>
	 <200708132325.04810.rjw@sisk.pl>
Content-Type: text/plain
Date: Mon, 13 Aug 2007 14:21:20 -0700
Message-Id: <1187040080.10249.323.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2-2.1mdv2007.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-08-13 at 23:25 +0200, Rafael J. Wysocki wrote:
> + include/linux/suspend.h
> + include/linux/freezer.h
> + include/linux/pm.h
> + include/asm-*/suspend.h
> 
> Hm, they are also relevant for suspend to RAM, so perhaps one common
> list of files for suspend to RAM and hibernation would be better?

Maybe just collapse the 2 maintainers blocks into one?

HIBERNATION (aka Software Suspend, aka swsusp) and SUSPEND TO RAM:
P:	Pavel Machek
M:	pavel@suse.cz
P:	Rafael J. Wysocki
M:	rjw@sisk.pl
L:	linux-pm@lists.linux-foundation.org
S:	Supported
F:	Documentation/power/swsusp*
F:	arch/i386/kernel/acpi/
F:	arch/i386/power/
F:	arch/x86_64/kernel/acpi/
F:	arch/x86_64/kernel/suspend_asm.S
F:	arch/x86_64/kernel/suspend.c
F:	drivers/base/power/
F:	kernel/power/
F:	include/linux/suspend.h
F:	include/linux/freezer.h
F:	include/linux/pm.h
F:	include/asm-*/suspend.h


