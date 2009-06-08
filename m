Return-Path: <linux-kernel-owner+w=401wt.eu-S1755409AbZFHLhf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755409AbZFHLhf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 07:37:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754713AbZFHLh2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 07:37:28 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:34899 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754686AbZFHLh1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 07:37:27 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jiri Kosina <jkosina@suse.cz>
Subject: Re: [Bug #13411] Barscanner (USB HID Keyboard) stopped functioning in kernels >= 2.6.28
Date: Mon, 8 Jun 2009 13:37:59 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc8-rjw; KDE/4.2.4; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Guido <bugzilla.kernel.org@starbase12.cjb.net>,
       Remi Cattiau <remi@cattiau.com>
References: <sIiXQlfwS3D.A.81.dj7KKB@chimera> <AN6kEAA5GQ.A.g8.vj7KKB@chimera> <alpine.LNX.2.00.0906081302010.7457@wotan.suse.de>
In-Reply-To: <alpine.LNX.2.00.0906081302010.7457@wotan.suse.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906081338.00278.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 08 June 2009, Jiri Kosina wrote:
> On Sun, 7 Jun 2009, Rafael J. Wysocki wrote:
> 
> > This message has been generated automatically as a part of a report
> > of regressions introduced between 2.6.28 and 2.6.29.
> > 
> > The following bug entry is on the current list of known regressions
> > introduced between 2.6.28 and 2.6.29.  Please verify if it still should
> > be listed and let me know (either way).
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13411
> > Subject		: Barscanner (USB HID Keyboard) stopped functioning in kernels >= 2.6.28
> > Submitter	: Guido <bugzilla.kernel.org@starbase12.cjb.net>
> > Date		: 2009-05-31 12:21 (8 days old)
> 
> This is apparently caused by vendor releasing two different hardware 
> products under the same VID/PID and just one of them needing blacklist 
> entry. Sigh.

Oh well.

> Waiting for verbose lsusb output from Remi, so that we could compare it 
> with the output provided by the bug reporter, to see what else could be 
> done to distinguish the devices from each other.

Thanks for the update.

Best,
Rafael
