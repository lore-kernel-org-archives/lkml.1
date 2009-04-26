Return-Path: <linux-kernel-owner+w=401wt.eu-S1754920AbZDZXPh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754920AbZDZXPh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Apr 2009 19:15:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752882AbZDZXPa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Apr 2009 19:15:30 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:45855 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752366AbZDZXP3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Apr 2009 19:15:29 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [Bug #13114] USB storage (usbstick) automount woes
Date: Mon, 27 Apr 2009 01:15:23 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc3-rjw; KDE/4.2.2; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Greg Kroah-Hartman" <gregkh@suse.de>, Mike Galbraith <efault@gmx.de>
References: <Pine.LNX.4.44L0.0904261457540.24895-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0904261457540.24895-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904270115.23850.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 26 April 2009, Alan Stern wrote:
> On Sat, 25 Apr 2009, Rafael J. Wysocki wrote:
> 
> > This message has been generated automatically as a part of a report
> > of recent regressions.
> > 
> > The following bug entry is on the current list of known regressions
> > from 2.6.29.  Please verify if it still should be listed and let me know
> > (either way).
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13114
> > Subject		: USB storage (usbstick) automount woes
> > Submitter	: Mike Galbraith <efault@gmx.de>
> > Date		: 2009-04-09 9:26 (17 days old)
> > First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=e6e244b6cb1f70e7109381626293cd40a8334ed3
> > References	: http://marc.info/?l=linux-kernel&m=123926928907568&w=4
> > Handled-By	: Alan Stern <stern@rowland.harvard.edu>
> 
> This has been fixed by commit dfc15e8955338fedf5c5d15622c4042c1e4ee332.

Thanks, closed.

Rafael
