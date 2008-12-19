Return-Path: <linux-kernel-owner+w=401wt.eu-S1753091AbYLSA0d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753091AbYLSA0d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2008 19:26:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752047AbYLSA0W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 19:26:22 -0500
Received: from mail.suse.de ([195.135.220.2]:39205 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752018AbYLSA0V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 19:26:21 -0500
From: "NeilBrown" <neilb@suse.de>
To: "Dylan Taft" <d13f00l@gmail.com>
Date: Fri, 19 Dec 2008 11:26:12 +1100 (EST)
Message-ID: <14ab805319e6bb1c0353ac078f41b21f.squirrel@neil.brown.name>
In-Reply-To: <47ed01bd0812181603t53a500adgadab6884a7a4a586@mail.gmail.com>
References: <47ed01bd0812172033p1065b472t62491e4f2eed901@mail.gmail.com>
    <20081218065603.GA21265@mail.local.tull.net>
    <47ed01bd0812180508t89d1aecr13d2b9e8402ed885@mail.gmail.com>
    <44f470466dcf22c47f6700502caf9cbd.squirrel@neil.brown.name>
    <47ed01bd0812181603t53a500adgadab6884a7a4a586@mail.gmail.com>
Subject: Re: MDADM Software Raid Woes
Cc: "Nick Andrew" <nick@nick-andrew.net>, linux-kernel@vger.kernel.org,
       linux-raid@vger.kernel.org
User-Agent: SquirrelMail/1.4.15
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, December 19, 2008 11:03 am, Dylan Taft wrote:
> I'm running gentoo, udev 124-r1
> I cleared all superblocks on all devices I raided, and undid all the
> partition tables, and started from scratch, putting the filesystem on
> the raid devices themselves instead of partitioning the raid devices.
>
> Everything is working now, I think it's probably best to keep it
> simple, or use LVM
> MD is referenced in the udev config files, but everything is working now.
>
> Sorry, I think it was user error. :)
> Thanks
> Dylan

Only broken systems allow users to make errors like that.

I'd still like to see the relevant udev config files if you
wouldn't mind.  I'd like to see if I can stop other people from
suffering the same misfortunes as you.


Thanks.
NeilBrown

