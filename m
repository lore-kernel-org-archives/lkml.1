Return-Path: <linux-kernel-owner+w=401wt.eu-S1760224AbZDQViz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760224AbZDQViz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 17:38:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754867AbZDQViq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 17:38:46 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:43094 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752651AbZDQVip (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 17:38:45 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Thomas Meyer <thomas@m3y3r.de>
Subject: Re: 2.6.30-rc2-git2: Reported regressions from 2.6.29
Date: Fri, 17 Apr 2009 23:38:35 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc2-rjw; KDE/4.2.2; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
References: <EJaiQ4Wfaz.A.3YG.4v85JB@chimera> <20090417190943.411479vadrij472v@mail.your-server.de>
In-Reply-To: <20090417190943.411479vadrij472v@mail.your-server.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904172338.36389.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 17 April 2009, Thomas Meyer wrote:
> 
> Zitat von "Rafael J. Wysocki" <rjw@sisk.pl>:
> 
> > If you know of any other unresolved regressions from 2.6.29, please  
> > let me know
> > either and I'll add them to the list.  Also, please let me know if any of the
> > entries below are invalid.
> 
> Two things on 2.6.30-rc2:
> 
> 1) Kernel panic while shutting down the system:
> http://m3y3r.de/wordpress/?p=67

Can you pleaes open a Bugzilla entry for this one (please add my address to the
CC list of the bug entry)?

> 2) Backlight daemon dies (hald-addon-macbookpro-backlight). Don't know why.

Isn't that bug #13048?

Rafael
