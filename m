Return-Path: <linux-kernel-owner+w=401wt.eu-S1758729AbXFRABg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758729AbXFRABg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 20:01:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751147AbXFRAB2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 20:01:28 -0400
Received: from mail.suse.de ([195.135.220.2]:34575 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751108AbXFRAB2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 20:01:28 -0400
Date: Mon, 18 Jun 2007 02:01:14 +0200
From: Andrea Arcangeli <andrea@suse.de>
To: Chris Adams <cmadams@hiwaay.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
Message-ID: <20070618000113.GB4542@v2.random>
References: <fa.toMqQ3LqoQn6Xh51bVordO8WMVc@ifi.uio.no> <fa.EmnDne9QndTLcw7NAzc83tWplMI@ifi.uio.no> <fa.G+0vGcF8U8pcd6ozkdhKGsQ/dDs@ifi.uio.no> <fa.8bXRW7nY7z5eXVZxCxUgra+gbb8@ifi.uio.no> <fa.qtDtq+aSKlNweTqHtKcy/Gj5PXg@ifi.uio.no> <20070617215840.GA1217855@hiwaay.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070617215840.GA1217855@hiwaay.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 17, 2007 at 04:58:40PM -0500, Chris Adams wrote:
> The reason is that if there ever is a security hole in the routing
> engine software (FreeBSD kernel, OpenSSH, etc.), it would be a really
> bad thing if crackers could load arbitrary software (rootkits, spam
> software, etc.) directly on Internet core routers.  If you think spam
> zombies on cable modems or DSL are bad, imagine them on 100 megabit
> links!

Not sure if it's a good example, keep in mind that at the first
exploitable software bug any hardware DRM breaks apart.

But since you made a BSD-embedded example, this shows how the only
really important thing is that by using linux instead of BSD, they
can't make huge improvements or important security bugfixes to the
routing engine, without us being able to incorporate them in our "home
firewalls", that's the whole difference with BSD and it explains the
spirit of the gpl pretty well and in the end why linux by definition
can receive more contributions and in turn be technically
superior. Whatever the vendor does with the gpl code is generally up
to him, and if it uses the closed approach it'll allow somebody else
to sell a "open" router (potentially at an higher price). Economy
101. The worry that nobody will step in and sell an "open" equivalent
is a red herring. Infact I wouldn't be so certain that openmoko would
exist if the current linux cellphones would be already totally open!
Now I know this all probably sounds boring talk, but I think it's much
closer to reality than the prospect of a trusted computing and/or DRM
apocalypse.
