Return-Path: <linux-kernel-owner+w=401wt.eu-S1754357AbYHMMpt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754357AbYHMMpt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 08:45:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752719AbYHMMpl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 08:45:41 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:4475 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752543AbYHMMpk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 08:45:40 -0400
Date: Wed, 13 Aug 2008 14:45:29 +0200
From: Pavel Machek <pavel@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: andi@firstfloor.org, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org, trivial@kernel.org
Subject: Re: acpi: trivial cleanups
Message-ID: <20080813124529.GA6995@ucw.cz>
References: <20080812102434.GA2676@elf.ucw.cz> <20080812162013.b139035b.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080812162013.b139035b.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2008-08-12 16:20:13, Andrew Morton wrote:
> On Tue, 12 Aug 2008 12:24:34 +0200
> Pavel Machek <pavel@suse.cz> wrote:
> 
> > 
> > Trivial cleanups for ACPI. Fix misspelling in printk(), fix mismerge,
> > add file header.
...
> > +++ b/drivers/acpi/reboot.c
> > @@ -1,4 +1,8 @@
> > -
> > +/*
> > + * Reset the machine using the RESET_REG
> > + *
> > + * Distribute under GPL.
> > + */
> 
> That was a trivial dirtyup.  Should at least be "Distributed under the
> GPL" but I suspect that the policy in drivers/acpi/ is to add fancier
> copyright text than this.

Ok, sorry about that.
							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
