Return-Path: <linux-kernel-owner+w=401wt.eu-S944848AbXHMVNc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S944848AbXHMVNc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 17:13:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762690AbXHMVMj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 17:12:39 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:37784 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765823AbXHMVMi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 17:12:38 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Joe Perches <joe@perches.com>
Subject: Re: [PATCH] [444/2many] MAINTAINERS - SUSPEND TO RAM:
Date: Mon, 13 Aug 2007 23:22:15 +0200
User-Agent: KMail/1.9.5
Cc: torvalds@linux-foundation.org, pavel@suse.cz,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
References: <46bffbd5.kKrnXsYdLyNKojxF%joe@perches.com> <200708132252.55738.rjw@sisk.pl> <1187038670.10249.307.camel@localhost>
In-Reply-To: <1187038670.10249.307.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708132322.16316.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 13 August 2007 22:57, Joe Perches wrote:
> On Mon, 2007-08-13 at 22:52 +0200, Rafael J. Wysocki wrote:
> > +F:	drivers/base/power
> > +F:	arch/x86_64/kernel/acpi
> > +F:	arch/i386/kernel/acpi/
> 
> What about arch/x86_64/kernel/acpi.c ?

Well, there's no such file in current -git.

> Perhaps:
> 
> SUSPEND TO RAM:
> P:	Pavel Machek
> M:	pavel@suse.cz
> P:	Rafael J. Wysocki
> M:	rjw@sisk.pl
> L:	linux-pm@lists.linux-foundation.org
> S:	Maintained
> F:	arch/x86_64/kernel/acpi.c

Please remove the above

> F:	arch/x86_64/kernel/acpi/
> F:	arch/i386/kernel/acpi/
> F:	drivers/base/power
> F:	kernel/power/
> 
> 
> 
> 

-- 
"Premature optimization is the root of all evil." - Donald Knuth
