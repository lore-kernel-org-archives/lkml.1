Return-Path: <linux-kernel-owner+w=401wt.eu-S1754155AbZG0WtE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754155AbZG0WtE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 18:49:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751553AbZG0WtD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 18:49:03 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:37135 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750833AbZG0WtB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 18:49:01 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Gene Heskett <gene.heskett@verizon.net>
Subject: Re: [Bug #13841] 2.6.31-rc4 boot failure
Date: Tue, 28 Jul 2009 00:49:26 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.31-rc4-rjw; KDE/4.2.4; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
References: <Jya1GruKQpD.A.16.2GObKB@chimera> <3zAHs5O6maO.A.olB.EHObKB@chimera> <200907270020.23019.gene.heskett@verizon.net>
In-Reply-To: <200907270020.23019.gene.heskett@verizon.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907280049.26580.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 27 July 2009, Gene Heskett wrote:
> On Sunday 26 July 2009, Rafael J. Wysocki wrote:
> >This message has been generated automatically as a part of a report
> >of recent regressions.
> >
> >The following bug entry is on the current list of known regressions
> >from 2.6.30.  Please verify if it still should be listed and let me know
> >(either way).
> >
> Yes.  I have nuked the odd stuff in my rc.local file, and rebuilt this kernel 
> with several mods that I thought might be related, but it is still failing in 
> the same manner.  The error messages (apparently from lp:, but long after cups 
> has been started) do NOT make it to the messages log file either, so its 
> totally blown up at that point.
> 
> Note, that this is a regression from 2.6 31-rc3, which works fine.  So the 
> thing shouldn't be that hard to find.  But in looking over the changelog, 
> nothing obviously reaches out and grabs me.
> 
> I'm not really equipt to do a bisect here either, my git from F10 is at least 
> 2 versions old now.  And I'm crippled by a way too small /boot partition which 
> can't hold more than 12-14 kernels.  The disk partitioning tool in F10 is 
> nothing short of fscking broken IMO. But fedora isn't interested in that 
> either, cuz its existed since at least Fedora 2.  Here, fedora is on its way 
> out, 64 bit mandriva sure looks nice.  And DiskDrake Just Works(TM).
> 
> Thanks Rafael, I thought it was being ignored.

You're welcome, thanks for the update.

Rafael
