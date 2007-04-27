Return-Path: <linux-kernel-owner+w=401wt.eu-S1757503AbXD0WeK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757503AbXD0WeK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 18:34:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757504AbXD0WeK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 18:34:10 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:48022 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757503AbXD0WeG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 18:34:06 -0400
Date: Fri, 27 Apr 2007 17:42:11 -0500
From: Josh Boyer <jwboyer@linux.vnet.ibm.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Artem Bityutskiy <dedekind@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       David Woodhouse <dwmw2@infradead.org>,
       Frank Haverkamp <haver@vnet.ibm.com>
Subject: Re: [GIT-PULL] please pull UBI tree
Message-ID: <20070427224211.GG23995@crusty.rchland.ibm.com>
References: <1177677925.7539.18.camel@sauron> <alpine.LFD.0.98.0704270855300.9964@woody.linux-foundation.org> <20070427135224.58d54065.akpm@linux-foundation.org> <20070427142254.3aa89a16.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070427142254.3aa89a16.randy.dunlap@oracle.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 27, 2007 at 02:22:54PM -0700, Randy Dunlap wrote:
> On Fri, 27 Apr 2007 13:52:24 -0700 Andrew Morton wrote:
> > The patchset used to contain lots of debugging support which wildly
> > duplicated thigs which we already did and was generally overdone.  That
> > appears to all have been cleaned up now, so thanks for doing that.
> > 
> > The one remaining nit I'd have with the debug code is that it adds a
> > private hexdump() facility.  By my count, that is the kernel's eighth
> > hexdump implementation.  There may be even more which don't have "hexdump"
> > in their name.
> > 
> > lib/hexdump.c is rather overdue.
> 
> I have a version of that from James Ketrenos that I have been working
> on...  Can post in a few days.

Excellent.  We'll take a look at it as soon as you do.

josh
