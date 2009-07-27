Return-Path: <linux-kernel-owner+w=401wt.eu-S1755257AbZG0V6s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755257AbZG0V6s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 17:58:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754131AbZG0V6r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 17:58:47 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:36754 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751634AbZG0V6r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 17:58:47 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [Bug #13624] usb: wrong autosuspend initialization
Date: Mon, 27 Jul 2009 23:59:21 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.31-rc4-rjw; KDE/4.2.4; x86_64; ; )
Cc: Oliver Neukum <oliver@neukum.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>, list@phuk.ath.cx
References: <Pine.LNX.4.44L0.0907271041040.5614-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0907271041040.5614-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907272359.22268.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 27 July 2009, Alan Stern wrote:
> On Sun, 26 Jul 2009, Rafael J. Wysocki wrote:
> 
> > This message has been generated automatically as a part of a report
> > of regressions introduced between 2.6.29 and 2.6.30.
> > 
> > The following bug entry is on the current list of known regressions
> > introduced between 2.6.29 and 2.6.30.  Please verify if it still should
> > be listed and let me know (either way).
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13624
> > Subject		: usb: wrong autosuspend initialization
> > Submitter	:  <list@phuk.ath.cx>
> > Date		: 2009-06-25 18:18 (32 days old)
> 
> There's some question as to whether this should be considered a kernel 
> bug.  The kernel isn't doing anything wrong; the problem is that 
> various userspace programs enable autosuspend for devices that can't 
> support it properly.

OK, I'll drop it from the list of recent regressions.

Thanks,
Rafael
