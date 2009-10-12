Return-Path: <linux-kernel-owner+w=401wt.eu-S933260AbZJLVir@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933260AbZJLVir (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 17:38:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758380AbZJLViq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 17:38:46 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:36318 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758367AbZJLVip (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 17:38:45 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Steven Noonan <steven@uplinklabs.net>
Subject: Re: [Bug #14377] "conservative" cpufreq governor broken
Date: Mon, 12 Oct 2009 23:39:46 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.32-rc3-rjw; KDE/4.3.1; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Eero Nurkkala <ext-eero.nurkkala@nokia.com>,
       Rik van Riel <riel@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
References: <56acieJJ2fF.A.nEB.Hzl0KB@chimera> <L6tb-VyKHZK.A.lrB.Rzl0KB@chimera> <f488382f0910111847y365ad85fj89fc8c65d510052b@mail.gmail.com>
In-Reply-To: <f488382f0910111847y365ad85fj89fc8c65d510052b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200910122339.46127.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 12 October 2009, Steven Noonan wrote:
> Hi Rafael,
> 
> There's a commit to fix this in the stable queue for 2.6.31.x and said
> fix is already in the 2.6.32 tree. The commit is titled "NOHZ: update
> idle state also when NOHZ is inactive" (fdc6f192e7).

Thanks, closing.

Rafael
