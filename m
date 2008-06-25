Return-Path: <linux-kernel-owner+w=401wt.eu-S1758860AbYFYQOX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758860AbYFYQOX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 12:14:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755421AbYFYQOP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 12:14:15 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:59499 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752857AbYFYQOO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 12:14:14 -0400
Date: Wed, 25 Jun 2008 18:14:04 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Frederik Schwarzer <schwarzerf@gmail.com>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] some typo fixes in docs and comments
Message-ID: <20080625161404.GE24967@elte.hu>
References: <200806241611.17959.schwarzerf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200806241611.17959.schwarzerf@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Frederik Schwarzer <schwarzerf@gmail.com> wrote:

> Hi,
> 
> while reading the help of a kernel module config, I found a typo. 
> Since this is a quite common typo, I looked for it further and fixed 
> it where I found it.
> 
> I hope this is the right address for this kind of things.
> 
> Regards,
> Frederik
> 
> ---
>  Documentation/dell_rbu.txt              |    4 ++--
>  Documentation/laptops/thinkpad-acpi.txt |    2 +-
>  Documentation/networking/tuntap.txt     |    2 +-
>  arch/m68k/kernel/traps.c                |    2 +-
>  drivers/acpi/executer/exprep.c          |    2 +-
>  drivers/acpi/executer/exresolv.c        |    2 +-
>  drivers/acpi/executer/exstore.c         |    2 +-
>  drivers/acpi/resources/rscreate.c       |    2 +-
>  drivers/acpi/utilities/utobject.c       |    4 ++--
>  drivers/char/epca.c                     |    2 +-
>  drivers/cpufreq/Kconfig                 |    4 ++--
>  drivers/input/keyboard/atkbd.c          |    2 +-
>  drivers/macintosh/Kconfig               |    2 +-
>  drivers/misc/phantom.c                  |    2 +-
>  fs/ncpfs/ioctl.c                        |    2 +-
>  include/acpi/acmacros.h                 |    2 +-
>  include/acpi/actypes.h                  |    2 +-
>  include/asm-x86/desc_defs.h             |    2 +-
>  include/linux/ncp_fs.h                  |    2 +-
>  mm/slub.c                               |    2 +-
>  sound/oss/aedsp16.c                     |    2 +-
>  21 files changed, 24 insertions(+), 24 deletions(-)

the x86 bits are looking fine - and the other ones seem OK too.

Acked-by: Ingo Molnar <mingo@elte.hu>

	Ingo
