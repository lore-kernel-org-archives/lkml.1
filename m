Return-Path: <linux-kernel-owner+w=401wt.eu-S965671AbXHMVB4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965671AbXHMVB4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 17:01:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S971678AbXHMU7G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 16:59:06 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:3701 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S971662AbXHMU7E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 16:59:04 -0400
Subject: Re: [PATCH] [444/2many] MAINTAINERS - SUSPEND TO RAM:
From: Joe Perches <joe@perches.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: torvalds@linux-foundation.org, pavel@suse.cz,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
In-Reply-To: <200708132252.55738.rjw@sisk.pl>
References: <46bffbd5.kKrnXsYdLyNKojxF%joe@perches.com>
	 <200708132252.55738.rjw@sisk.pl>
Content-Type: text/plain
Date: Mon, 13 Aug 2007 13:57:50 -0700
Message-Id: <1187038670.10249.307.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2-2.1mdv2007.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-08-13 at 22:52 +0200, Rafael J. Wysocki wrote:
> +F:	drivers/base/power
> +F:	arch/x86_64/kernel/acpi
> +F:	arch/i386/kernel/acpi/

What about arch/x86_64/kernel/acpi.c ?

Perhaps:

SUSPEND TO RAM:
P:	Pavel Machek
M:	pavel@suse.cz
P:	Rafael J. Wysocki
M:	rjw@sisk.pl
L:	linux-pm@lists.linux-foundation.org
S:	Maintained
F:	arch/x86_64/kernel/acpi.c
F:	arch/x86_64/kernel/acpi/
F:	arch/i386/kernel/acpi/
F:	drivers/base/power
F:	kernel/power/


