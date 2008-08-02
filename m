Return-Path: <linux-kernel-owner+w=401wt.eu-S1756033AbYHBOhU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756033AbYHBOhU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Aug 2008 10:37:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751003AbYHBOhI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Aug 2008 10:37:08 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:29162 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752783AbYHBOhH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Aug 2008 10:37:07 -0400
Message-ID: <10758824.1217687776711.JavaMail.oracle@acsmt303.oracle.com>
Date: Sat, 2 Aug 2008 09:36:16 -0500 (CDT)
From: Randy Dunlap <randy.dunlap@oracle.com>
To: "Robert P. J. Day" <rpjday@crashcourse.ca>,
       Calvin Walton <calvin.walton@gmail.com>, Andrew Morton <akpm@osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       7eggert@gmx.de
Subject: Re: [PATCH] FILESYSTEMS: Make "advanced partitions" immediately  unselectable.
In-Reply-To: <E1KPGQ3-0001T9-RS@be1.7eggert.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
References: <aTS0O-4U1-33@gated-at.bofh.it> <aTV89-39s-5@gated-at.bofh.it> <aTZYh-4i3-21@gated-at.bofh.it> <aUrrl-78m-3@gated-at.bofh.it> <aUxwQ-1Hn-19@gated-at.bofh.it> <aUERB-Zl-5@gated-at.bofh.it> <aUFXh-3m9-3@gated-at.bofh.it> <aUJ4U-1xe-19@gated-at.bofh.it> <aUJeD-1N6-13@gated-at.bofh.it> <aUUME-5MM-11@gated-at.bofh.it> <aV05W-1wO-41@gated-at.bofh.it> <E1KPGQ3-0001T9-RS@be1.7eggert.dyndns.org>
X-Priority: 3
X-Mailer: Oracle Webmail Client(UIX)
Content-Language: en-US
Accept-Language: en-US
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--- Original Message ---
> Randy Dunlap <randy.dunlap@oracle.com> wrote:
> 
> > I don't see the "if PARTITION_ADVANCED" block as being compatible with the
> > need to have default partition types per $ARCH.
> > Do you see some way around that problem?
> 
> You need menuconfig_usedefaults.

Where is that?

~Randy


