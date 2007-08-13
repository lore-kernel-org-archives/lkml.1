Return-Path: <linux-kernel-owner+w=401wt.eu-S966422AbXHMU5t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966422AbXHMU5t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 16:57:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S938662AbXHMUzw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 16:55:52 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:3693 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S939213AbXHMUzs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 16:55:48 -0400
Subject: Re: [PATCH] [443/2many] MAINTAINERS - HIBERNATION (aka Software
	Suspend, aka swsusp):
From: Joe Perches <joe@perches.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: torvalds@linux-foundation.org, pavel@suse.cz,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
In-Reply-To: <200708132250.15466.rjw@sisk.pl>
References: <46bffbd3.IqsNHrHU1Y9BF7Dd%joe@perches.com>
	 <200708132250.15466.rjw@sisk.pl>
Content-Type: text/plain
Date: Mon, 13 Aug 2007 13:54:39 -0700
Message-Id: <1187038479.10249.304.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2-2.1mdv2007.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-08-13 at 22:50 +0200, Rafael J. Wysocki wrote:
> Please add
> arch/i386/power/
> arch/x86_64/kernel/suspend_asm.S
> arch/x86_64/kernel/suspend.c
> drivers/base/power/
> There also is a couple of headers.  Do you want to list them too?

Your choice.  Just let me know.

HIBERNATION (aka Software Suspend, aka swsusp):
P:	Pavel Machek
M:	pavel@suse.cz
P:	Rafael J. Wysocki
M:	rjw@sisk.pl
L:	linux-pm@lists.linux-foundation.org
S:	Supported
F:	Documentation/power/swsusp*
F:	arch/i386/power/
F:	arch/x86_64/kernel/suspend*
F:	drivers/base/power/
F:	kernel/power/



