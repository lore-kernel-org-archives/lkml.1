Return-Path: <linux-kernel-owner+w=401wt.eu-S1755173AbYJTXCo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755173AbYJTXCo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 19:02:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753599AbYJTXCg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 19:02:36 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:3784 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753509AbYJTXCf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 19:02:35 -0400
Subject: Re: [PATCH 1/3] Add file patterns to MAINTAINERS
From: Joe Perches <joe@perches.com>
To: Dominik Brodowski <linux@dominikbrodowski.net>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Randy Dunlap <randy.dunlap@oracle.com>, Pavel Machek <pavel@suse.cz>,
       Uwe =?ISO-8859-1?Q?Kleine-K=F6nig?= <ukleinek@strlen.de>
In-Reply-To: <20081020225058.GA7184@isilmar.linta.de>
References: <1224541704-30357-1-git-send-email-joe@perches.com>
	 <1224541704-30357-2-git-send-email-joe@perches.com>
	 <20081020225058.GA7184@isilmar.linta.de>
Content-Type: text/plain
Date: Mon, 20 Oct 2008 16:02:26 -0700
Message-Id: <1224543747.12101.66.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.0-2mdv2009.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-10-21 at 00:50 +0200, Dominik Brodowski wrote:
> Hi,
> 
> >  PCMCIA SUBSYSTEM
> >  P:	Linux PCMCIA Team
> >  L:	linux-pcmcia@lists.infradead.org
> >  W:	http://lists.infradead.org/mailman/listinfo/linux-pcmcia
> >  T:	git kernel.org:/pub/scm/linux/kernel/git/brodo/pcmcia-2.6.git
> >  S:	Maintained
> > +F:	Documentation/pcmcia/
> > +F:	drivers/*/pcmcia/
> > +F:	drivers/pcmcia/
> > +F:	include/pcmcia/
> > +F:	sound/pcmcia/
> 
> sound/pcmcia/ and lots of drivers/*/pcmcia is actually really
> driver-related and not PCMCIA related so I'm not really happy if this will
> be described by the PCMCIA F:-realm...

I generated that pattern from patchsets like:
http://lists.infradead.org/pipermail/linux-pcmcia/2008-August/005787.html

If you could send a more correct pattern,
it's easy to change.

cheers, Joe

