Return-Path: <linux-kernel-owner+w=401wt.eu-S1755848AbZDZS66@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755848AbZDZS66 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Apr 2009 14:58:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752818AbZDZS6t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Apr 2009 14:58:49 -0400
Received: from netrider.rowland.org ([192.131.102.5]:45003 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751565AbZDZS6s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Apr 2009 14:58:48 -0400
Date: Sun, 26 Apr 2009 14:58:48 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, Mike Galbraith <efault@gmx.de>
Subject: Re: [Bug #13114] USB storage (usbstick) automount woes
In-Reply-To: <Fg2zLW93smL.A.CQE.cd48JB@chimera>
Message-ID: <Pine.LNX.4.44L0.0904261457540.24895-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 25 Apr 2009, Rafael J. Wysocki wrote:

> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.29.  Please verify if it still should be listed and let me know
> (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13114
> Subject		: USB storage (usbstick) automount woes
> Submitter	: Mike Galbraith <efault@gmx.de>
> Date		: 2009-04-09 9:26 (17 days old)
> First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=e6e244b6cb1f70e7109381626293cd40a8334ed3
> References	: http://marc.info/?l=linux-kernel&m=123926928907568&w=4
> Handled-By	: Alan Stern <stern@rowland.harvard.edu>

This has been fixed by commit dfc15e8955338fedf5c5d15622c4042c1e4ee332.

Alan Stern

