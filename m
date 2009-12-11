Return-Path: <linux-kernel-owner+w=401wt.eu-S1762649AbZLKVHr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762649AbZLKVHr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 16:07:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758821AbZLKVHp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 16:07:45 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:36729 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757302AbZLKVHp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 16:07:45 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [PATCH] PM: Fix kernel-doc notation
Date: Fri, 11 Dec 2009 22:08:29 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.32-rjw; KDE/4.3.3; x86_64; ; )
Cc: Jaswinder Singh Rajput <jaswinder@kernel.org>, Pavel Machek <pavel@ucw.cz>,
       linux-pm@lists.linux-foundation.org,
       LKML <linux-kernel@vger.kernel.org>
References: <1258877637.4495.45.camel@ht.satnam> <20091211120259.82de239d.randy.dunlap@oracle.com>
In-Reply-To: <20091211120259.82de239d.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200912112208.29241.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 11 December 2009, Randy Dunlap wrote:
> On Sun, 22 Nov 2009 13:43:57 +0530 Jaswinder Singh Rajput wrote:
> 
> > 
> > Fix the following htmldocs warnings:
> > 
> >   Warning(drivers/base/power/main.c:249): No description found for parameter 'master'
> >   Warning(drivers/base/power/main.c:249): Excess function parameter 'slave' description in 'device_pm_wait_for_slaves'
> >   Warning(drivers/base/power/main.c:292): No description found for parameter 'master'
> >   Warning(drivers/base/power/main.c:292): Excess function parameter 'slave' description in 'device_pm_check_slaves'
> > 
> > Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
> > Cc: Rafael J. Wysocki <rjw@sisk.pl>
> > Cc: Pavel Machek <pavel@ucw.cz>
> > Cc: Randy Dunlap <randy.dunlap@oracle.com>
> 
> What tree was this for?
> I guess it's not needed now, I can't find these functions..

It was on top of the async suspend/resume patches that Linus has rejected.

Rafael
