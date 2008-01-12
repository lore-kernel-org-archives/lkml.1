Return-Path: <linux-kernel-owner+w=401wt.eu-S1758929AbYALTZD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758929AbYALTZD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jan 2008 14:25:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751372AbYALTYx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jan 2008 14:24:53 -0500
Received: from wa-out-1112.google.com ([209.85.146.181]:12779 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750962AbYALTYw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jan 2008 14:24:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=dWk2VXkonX555reQJvbr2xDC/ydt0jpGTwTHdk9b+3q2gEIMmk3nFfYWtDrUXET+k/sYTC0zP1PodvYteOpkgr36VniMVOZ0FG6ukt5GmhpnjJX7TG4PnmDlzUOWFqxB912Tz9vsslPSYBjSgFsGwANgemA3qXP4oFOS8sSHBlA=
Message-ID: <e38d12ff0801121124u46c68d03w294d078501d3cf2c@mail.gmail.com>
Date: Sat, 12 Jan 2008 14:24:52 -0500
From: "Andrey Vul" <andrey.vul@gmail.com>
To: "Theodore Tso" <tytso@mit.edu>, "Tuomo Valkonen" <tuomov@iki.fi>,
       linux-kernel@vger.kernel.org
Subject: Re: The ext3 way of journalling
In-Reply-To: <20080112150621.GC6751@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <slrnfo77tv.2rr.tuomov@jolt.modeemi.cs.tut.fi>
	 <18307.42821.166376.732473@stoffel.org>
	 <slrnfo7auq.6m2.tuomov@jolt.modeemi.cs.tut.fi>
	 <871w8r6ruc.fsf@barad-dur.regala.cx>
	 <slrnfo9lqk.17l.tuomov@jolt.modeemi.cs.tut.fi>
	 <20080110131659.GF10230@mit.edu>
	 <20080110134111.GA6254@jolt.modeemi.cs.tut.fi>
	 <20080112150621.GC6751@mit.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 12, 2008 10:06 AM, Theodore Tso <tytso@mit.edu> wrote:
[snip]
> Unfortunately Ubuntu users [snip] fit this demographic hugely, and
> Ubuntu refuses to fix this problem[1], so it's been personally very
> vexing, because the users complain to *me*, and I can't fix the problem,
> because it's a distribution init script issue.
Ubuntu refuses to be power user friendly. They've forgotten the True
Meaning (tm) of Linux and try to be Windows-friendly, i.e., No Choices
(tm).


> Maybe someday Ubuntu will get this right --- but I'm not counting on it.
The alternative CD installer still looks like a semi-dumbed-down
debian installer. Hell, even the command-line base install is severely
bloated - it's the exact opposite of LFS or gentoo.
Still, it's *usable* in comparison to the livecd.
>
> [1] Something about installer CD's, and not wanting to ask the users
> any questions, not even what time zone they are in, or some other
> crazyness.  I never completely understood the argument and their
> design constraints.
Idiot friendliness and no exceptions to power users (e.g.., bloated
init scripts, UUID fstab). I switched to debian-unstable ages ago
*just* because apt is _really_ easy to use. Which I use secondarily to
Gentoo, where things Just Work (tm), once you patch the package
ebuilds to process your .patch files anyway and, while the packages
have *lots* of patches, it doesn't bloat the code *and* you can
disable the patches with the "vanilla" USE flag.

-- 
Andrey Vul
