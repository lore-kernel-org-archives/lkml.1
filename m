Return-Path: <linux-kernel-owner+w=401wt.eu-S1762434AbYBSWAr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762434AbYBSWAr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 17:00:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761059AbYBSWAW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 17:00:22 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:53261 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762226AbYBSWAT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 17:00:19 -0500
Date: Tue, 19 Feb 2008 13:59:00 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Frans Pop <elendil@planet.nl>
Cc: Adrian Bunk <bunk@kernel.org>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Unable to continue testing of 2.6.25
Message-ID: <20080219135900.54936266@laptopd505.fenrus.org>
In-Reply-To: <200802192255.02152.elendil@planet.nl>
References: <200802171025.30590.elendil@planet.nl>
	<20080217131611.GA1403@cs181133002.pp.htv.fi>
	<200802192255.02152.elendil@planet.nl>
Organization: Intel
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Feb 2008 22:55:01 +0100
Frans Pop <elendil@planet.nl> wrote:

> On Sunday 17 February 2008, Adrian Bunk wrote:
> > The real problem is that the kernel seems to lack functionality you
> > require for doing some work.
> 
> Not sure how you reached that conclusion.
> 
> > Why does your work on the Debian Installer depend on VirtualBox and
> > can't be done with what the kernel already ships?
> 
> Work on the installer does not so much hard depend on VirtualBox (or
> any other emulator), but can be done much more effectively and
> efficiently using one.
> 
> It allows me to run the installer inside the emulator without the
> need for a second computer (and using the same keyboard). It allows
> me to take snapshots just before stages I'm interested in and then
> add debugging or try changes. If what I tried does not work, I can
> just revert to the snapshot and try something else without having to
> run the full installation from scratch. It allows me to easily test
> RAID setups without having multiple physical disks. Etc.
> 
> The fact that VirtualBox does not (yet) work for me with 2.6.25 means
> that I'm unable to run 2.6.25 on my main desktop and do any real
> work. Rebooting my desktop whenever I want to use VirtualBox is just
> not a realistic option.
> That in turn means that I cannot do any more testing of 2.6.25,

I assume you've read the other mails right and went to the virtualbox form
to get the small patch to make it work on .25 right?


-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
