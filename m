Return-Path: <linux-kernel-owner+w=401wt.eu-S1755269AbXFNS61@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755269AbXFNS61 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 14:58:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751563AbXFNS6T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 14:58:19 -0400
Received: from mx.logic.tuwien.ac.at ([128.130.175.19]:44646 "EHLO
	mx.logic.tuwien.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751191AbXFNS6T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 14:58:19 -0400
X-Greylist: delayed 2677 seconds by postgrey-1.27 at vger.kernel.org; Thu, 14 Jun 2007 14:58:18 EDT
Date: Thu, 14 Jun 2007 20:13:29 +0200
To: Pavel Machek <pavel@ucw.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Olaf Dietsche <olaf+list.linux-acpi@olafdietsche.de>,
       linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [2.6.22-rc3][ACPI?] Resume from s2r doesn't work.
Message-ID: <20070614181329.GA31277@gamma.logic.tuwien.ac.at>
References: <878xb35sje.fsf@goat.bogus.local> <20070612153102.GD5986@ucw.cz> <20070613173925.GA20628@gamma.logic.tuwien.ac.at> <200706132342.55336.rjw@sisk.pl> <878xb35sje.fsf@goat.bogus.local> <20070612153102.GD5986@ucw.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200706132342.55336.rjw@sisk.pl> <20070612153102.GD5986@ucw.cz>
User-Agent: Mutt/1.3.28i
From: Norbert Preining <preining@logic.at>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all!

On Die, 12 Jun 2007, Pavel Machek wrote:
> > When I resume, everything seems to come up (fan becomes busy, disk and
> > dvd spin up for a short time), but the machine is not responding to
> > anything - neither keyboard, mouse nor ping from another machine. The
> > laptop is effectively dead and only a power cycle helps.
> > 
> > I've tried a minimal config and init=/bin/bash as well, but the result
> > is the same.
> 
> Beeping patch? It is in -mm now. noapic nolapic and nosmp are useful,
> too.


Ok, no beeping at all. Nothing after resume, only fan. And I did not
forget to activate the BEEP line.

So where can I go from here? DSDT hacking? Anything else?

Best wishes

Norbert

-------------------------------------------------------------------------------
Dr. Norbert Preining <preining@logic.at>        Vienna University of Technology
Debian Developer <preining@debian.org>                         Debian TeX Group
gpg DSA: 0x09C5B094      fp: 14DF 2E6C 0307 BE6D AD76  A9C0 D2BF 4AA3 09C5 B094
-------------------------------------------------------------------------------
Anyone who is capable of getting themselves made President
should on no account be allowed to do the job.
                 --- Some wisdom from The Book.
                 --- Douglas Adams, The Hitchhikers Guide to the Galaxy
