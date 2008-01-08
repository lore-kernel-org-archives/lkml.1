Return-Path: <linux-kernel-owner+w=401wt.eu-S1756812AbYAHWyg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756812AbYAHWyg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 17:54:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753552AbYAHWyH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 17:54:07 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:43841 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753295AbYAHWyD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 17:54:03 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Top 10 kernel oopses for the week ending January 5th, 2008
Date: Tue, 8 Jan 2008 23:56:27 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Arjan van de Ven <arjan@linux.intel.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Kevin Winchester <kjwinchester@gmail.com>,
       "J. Bruce Fields" <bfields@fieldses.org>,
       Al Viro <viro@zeniv.linux.org.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       NetDev <netdev@vger.kernel.org>
References: <477FF149.4070609@linux.intel.com> <4783C95C.7050303@linux.intel.com> <alpine.LFD.1.00.0801081126200.3148@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.00.0801081126200.3148@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801082356.28258.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 8 of January 2008, Linus Torvalds wrote:
> 
> On Tue, 8 Jan 2008, Arjan van de Ven wrote:
> > 
> > ok done; I had to fizzle a bit because some things aren't *exactly* a 
> > BUG() statement but I track them anyway (things like the "sleeping in 
> > invalid context" check), so I had to somewhat arbitrarily assign 
> > categories for those. I might fine tune these over time some; if you or 
> > someone else sees problems with categorization please let me know
> 
> Looking good. I wonder if we could also have some way to cross-ref these 
> things with the regression list (notably try to get pointers to them in 
> the regression list). 

I'm thinking about that, but haven't invented any automated solution yet.
I only can manually add references to kerneloops.org, for now.

Greetings,
Rafael
