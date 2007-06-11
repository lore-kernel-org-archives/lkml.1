Return-Path: <linux-kernel-owner+w=401wt.eu-S1758701AbXFKLBF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758701AbXFKLBF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 07:01:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751897AbXFKLAv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 07:00:51 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:44537 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751905AbXFKLAu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 07:00:50 -0400
Date: Mon, 11 Jun 2007 13:00:43 +0200
From: Pavel Machek <pavel@ucw.cz>
To: david@lang.hm
Cc: Crispin Cowan <crispin@novell.com>, casey@schaufler-ca.com,
       Greg KH <greg@kroah.com>, Andreas Gruenbacher <agruen@suse.de>,
       Stephen Smalley <sds@tycho.nsa.gov>, jjohansen@suse.de,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [AppArmor 39/45] AppArmor: Profile loading and manipulation, pathname matching
Message-ID: <20070611110043.GD30166@elf.ucw.cz>
References: <700465.32295.qm@web36612.mail.mud.yahoo.com> <466C6451.6030907@novell.com> <Pine.LNX.4.64.0706102328200.6675@asgard.lang.hm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0706102328200.6675@asgard.lang.hm>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> ACPI should have taught everyone that sometimes putting an interpreter in 
> the kernel really is the best option. looking at the problems of bouncing 
> back out to userspace for file creation and renames it looks like a regex 
> in the kernel is a lot safer and more reliable.

What do ACPI and AA have in common?

* they both start with A

* there are both nightmare

* they both put interpretter into kernel

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
