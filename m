Return-Path: <linux-kernel-owner+w=401wt.eu-S965070AbXBVJ7H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965070AbXBVJ7H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 04:59:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964832AbXBVJ7H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 04:59:07 -0500
Received: from 81-174-11-161.f5.ngi.it ([81.174.11.161]:45414 "EHLO
	mail.enneenne.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965070AbXBVJ7G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 04:59:06 -0500
Date: Thu, 22 Feb 2007 10:59:31 +0100
From: Rodolfo Giometti <giometti@enneenne.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: linux-kernel@vger.kernel.org, linuxpps@ml.enneenne.com
Message-ID: <20070222095930.GH13924@enneenne.com>
References: <20070216185230.GO8882@enneenne.com> <20070221101644.GH3945@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070221101644.GH3945@ucw.cz>
Organization: GNU/Linux Device Drivers, Embedded Systems and Courses
X-PGP-Key: gpg --keyserver keyserver.linux.it --recv-keys D25A5633
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: 192.168.32.1
X-SA-Exim-Mail-From: giometti@enneenne.com
Subject: Re: [PATCH 1/1] LinuxPPS: Pulse per Second support for Linux
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mail.enneenne.com)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 21, 2007 at 10:16:45AM +0000, Pavel Machek wrote:
> Hi!
> 
> > @@ -0,0 +1,206 @@
> > +
> > +			PPS - Pulse Per Second
> > +			----------------------
> > +
> > +(C) Copyright 2007 Rodolfo Giometti <giometti@enneenne.com>
> 
> If you add copyright, add license, too.

Ok.

> No new /proc files, please.

Already removed. As soon as possible I'll repost a new patch.

Thanks!

Rodolfo

-- 

GNU/Linux Solutions                  e-mail:    giometti@enneenne.com
Linux Device Driver                             giometti@gnudd.com
Embedded Systems                     		giometti@linux.it
UNIX programming                     phone:     +39 349 2432127
