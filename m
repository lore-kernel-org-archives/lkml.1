Return-Path: <linux-kernel-owner+w=401wt.eu-S1755513AbYJTWvR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755513AbYJTWvR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 18:51:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751815AbYJTWvD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 18:51:03 -0400
Received: from isilmar.linta.de ([213.133.102.198]:38922 "EHLO linta.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751261AbYJTWvB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 18:51:01 -0400
Date: Tue, 21 Oct 2008 00:50:58 +0200
From: Dominik Brodowski <linux@dominikbrodowski.net>
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@osdl-foundation.org>,
       Randy Dunlap <randy.dunlap@oracle.com>, Pavel Machek <pavel@suse.cz>,
       Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= <ukleinek@strlen.de>
Subject: Re: [PATCH 1/3] Add file patterns to MAINTAINERS
Message-ID: <20081020225058.GA7184@isilmar.linta.de>
Mail-Followup-To: Dominik Brodowski <linux@dominikbrodowski.net>,
	Joe Perches <joe@perches.com>, linux-kernel@vger.kernel.org,
	Linus Torvalds <torvalds@osdl-foundation.org>,
	Randy Dunlap <randy.dunlap@oracle.com>,
	Pavel Machek <pavel@suse.cz>,
	Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= <ukleinek@strlen.de>
References: <1224541704-30357-1-git-send-email-joe@perches.com> <1224541704-30357-2-git-send-email-joe@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1224541704-30357-2-git-send-email-joe@perches.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

>  PCMCIA SUBSYSTEM
>  P:	Linux PCMCIA Team
>  L:	linux-pcmcia@lists.infradead.org
>  W:	http://lists.infradead.org/mailman/listinfo/linux-pcmcia
>  T:	git kernel.org:/pub/scm/linux/kernel/git/brodo/pcmcia-2.6.git
>  S:	Maintained
> +F:	Documentation/pcmcia/
> +F:	drivers/*/pcmcia/
> +F:	drivers/pcmcia/
> +F:	include/pcmcia/
> +F:	sound/pcmcia/

sound/pcmcia/ and lots of drivers/*/pcmcia is actually really
driver-related and not PCMCIA related so I'm not really happy if this will
be described by the PCMCIA F:-realm...

Best,
	Dominik
