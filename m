Return-Path: <linux-kernel-owner+w=401wt.eu-S1754202AbZG0WnS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754202AbZG0WnS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 18:43:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755421AbZG0WnR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 18:43:17 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:37086 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755418AbZG0WnR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 18:43:17 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Tobias Diedrich <ranma@tdiedrich.de>
Subject: Re: [Bug #13833] Kernel Oops when trying to suspend with ubifs mounted on block2mtd mtd device
Date: Tue, 28 Jul 2009 00:43:50 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.31-rc4-rjw; KDE/4.2.4; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       David Brownell <david-b@pacbell.net>,
       David Woodhouse <David.Woodhouse@intel.com>,
       Eric Miao <eric.y.miao@gmail.com>, Pavel Machek <pavel@ucw.cz>
References: <Jya1GruKQpD.A.16.2GObKB@chimera> <3zAHs5O6maO.A.gfC.QHObKB@chimera> <20090727091623.GA16229@yamamaya.is-a-geek.org>
In-Reply-To: <20090727091623.GA16229@yamamaya.is-a-geek.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907280043.51688.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 27 July 2009, Tobias Diedrich wrote:
> Rafael J. Wysocki wrote:
> > This message has been generated automatically as a part of a report
> > of recent regressions.
> > 
> > The following bug entry is on the current list of known regressions
> > from 2.6.30.  Please verify if it still should be listed and let me know
> > (either way).
> 
> 
> Well, the patch reverting the commit still applies to 2.6.31-rc4, so
> I assume the issue persists,but I have not tried an unpatched
> 2.6.31-rc4.

Thanks for the update.

Rafael
