Return-Path: <linux-kernel-owner+w=401wt.eu-S1754602AbYJUAan@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754602AbYJUAan (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 20:30:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751936AbYJUAaf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 20:30:35 -0400
Received: from isilmar.linta.de ([213.133.102.198]:52214 "EHLO linta.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751287AbYJUAae (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 20:30:34 -0400
Date: Tue, 21 Oct 2008 02:30:32 +0200
From: Dominik Brodowski <linux@dominikbrodowski.net>
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Randy Dunlap <randy.dunlap@oracle.com>, Pavel Machek <pavel@suse.cz>,
       Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= <ukleinek@strlen.de>
Subject: Re: [PATCH 1/3] Add file patterns to MAINTAINERS
Message-ID: <20081021003032.GA17556@isilmar.linta.de>
Mail-Followup-To: Dominik Brodowski <linux@dominikbrodowski.net>,
	Joe Perches <joe@perches.com>, linux-kernel@vger.kernel.org,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Randy Dunlap <randy.dunlap@oracle.com>,
	Pavel Machek <pavel@suse.cz>,
	Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= <ukleinek@strlen.de>
References: <1224541704-30357-1-git-send-email-joe@perches.com> <1224541704-30357-2-git-send-email-joe@perches.com> <20081020225058.GA7184@isilmar.linta.de> <1224543747.12101.66.camel@localhost> <20081020234553.GA13115@isilmar.linta.de> <1224547979.12101.90.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1224547979.12101.90.camel@localhost>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Oct 20, 2008 at 05:12:58PM -0700, Joe Perches wrote:
> On Tue, 2008-10-21 at 01:45 +0200, Dominik Brodowski wrote:
> > On Mon, Oct 20, 2008 at 04:02:26PM -0700, Joe Perches wrote:
> > > If you could send a more correct pattern,
> > > it's easy to change.
> 
> Would you keep any PCMCIA pattern?
> 
> Perhaps:
> F:	Documentation/pcmcia/
> F:	include/pcmcia/
> F:	drivers/pcmcia/cs*
> F:	drivers/pcmcia/pcmcia*
> F:	drivers/pcmcia/rsrc*

Documentation/pcmcia/
include/pcmcia/
drivers/pcmcia/

is fine to be in the PCMCIA camp -- the latter might be split up in future,
but let's leave it at this for the moment.

> > sound/pcmcia/		should be under		SOUND
> > drivers/net/pcmcia/	should be under		NETWORK DEVICE DRIVERS
> > drivers/scsi/pcmcia/	should be under		SCSI SUBSYSTEM
> > drivers/char/pcmcia/cm4000_cs.c			OMNIKEY CARDMAN 4000 DRIVER
> > drivers/char/pcmcia/cm4040_cs.c			OMNIKEY CARDMAN 4040 DRIVER
> 
> File patterns for these sections are setup as you suggested.

Thanks!

Best,
	Dominik
