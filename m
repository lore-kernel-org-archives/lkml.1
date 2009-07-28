Return-Path: <linux-kernel-owner+w=401wt.eu-S1754857AbZG1VPl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754857AbZG1VPl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 17:15:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754650AbZG1VPl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 17:15:41 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:43508 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754537AbZG1VPk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 17:15:40 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [Bug #13337] [post 2.6.29 regression] hang during suspend of b44/b43 modules
Date: Tue, 28 Jul 2009 23:15:53 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.31-rc4-rjw; KDE/4.2.4; x86_64; ; )
Cc: Jan Scholz <scholz@fias.uni-frankfurt.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Tomas Janousek <tomi@nomi.cz>,
       "John W. Linville" <linville@tuxdriver.com>
References: <tSdKBEwEOhE.A.2wF.s_oUKB@chimera> <87my6ovpjv.fsf@scholz.fias.uni-frankfurt.de> <1248794777.8113.13.camel@johannes.local>
In-Reply-To: <1248794777.8113.13.camel@johannes.local>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907282315.54085.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 28 July 2009, Johannes Berg wrote:
> On Tue, 2009-07-28 at 16:40 +0200, Jan Scholz wrote:
> 
> > The bug is still present in v2.6.31-rc4, it's still fixed by the patch
> > (see below) suggested as a test by Johannes.
> 
> Sorry, this completely dropped off my radar, I'll take a look today.
> Thanks for reminding me.

Thanks for the patch Johannes!

Best,
Rafael
