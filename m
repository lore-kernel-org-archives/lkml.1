Return-Path: <linux-kernel-owner+w=401wt.eu-S1764509AbXHMVTg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764509AbXHMVTg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 17:19:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752111AbXHMVTL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 17:19:11 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:3729 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751955AbXHMVTJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 17:19:09 -0400
Subject: Re: [PATCH] [444/2many] MAINTAINERS - SUSPEND TO RAM:
From: Joe Perches <joe@perches.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: torvalds@linux-foundation.org, pavel@suse.cz,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
In-Reply-To: <200708132322.16316.rjw@sisk.pl>
References: <46bffbd5.kKrnXsYdLyNKojxF%joe@perches.com>
	 <200708132252.55738.rjw@sisk.pl> <1187038670.10249.307.camel@localhost>
	 <200708132322.16316.rjw@sisk.pl>
Content-Type: text/plain
Date: Mon, 13 Aug 2007 14:17:26 -0700
Message-Id: <1187039846.10249.319.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2-2.1mdv2007.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-08-13 at 23:22 +0200, Rafael J. Wysocki wrote:
> > What about arch/x86_64/kernel/acpi.c ?
> Well, there's no such file in current -git.
> > F:	arch/x86_64/kernel/acpi.c
> Please remove the above

SUSPEND TO RAM:
P:	Pavel Machek
M:	pavel@suse.cz
P:	Rafael J. Wysocki
M:	rjw@sisk.pl
L:	linux-pm@lists.linux-foundation.org
S:	Maintained
F:	arch/x86_64/kernel/acpi/
F:	arch/i386/kernel/acpi/
F:	drivers/base/power
F:	kernel/power/


