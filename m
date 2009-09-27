Return-Path: <linux-kernel-owner+w=401wt.eu-S1752708AbZI0U7S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752708AbZI0U7S (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Sep 2009 16:59:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752499AbZI0U7S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Sep 2009 16:59:18 -0400
Received: from kroah.org ([198.145.64.141]:53359 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752276AbZI0U7R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Sep 2009 16:59:17 -0400
Date: Sun, 27 Sep 2009 13:53:48 -0700
From: Greg KH <greg@kroah.com>
To: Joe Perches <joe@perches.com>
Cc: Ingo Oeser <ioe-lkml@rameria.de>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: [PATCH 1/3] lib/vsprintf.c: Add %pU - ptr to a UUID/GUID
Message-ID: <20090927205348.GA32464@kroah.com>
References: <cover.1254030722.git.joe@perches.com>
 <1507728e0ea3deafa71c481d508a6e9765c92221.1254030722.git.joe@perches.com>
 <200909271245.34000.ioe-lkml@rameria.de>
 <1254078046.28232.183.camel@Joe-Laptop.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1254078046.28232.183.camel@Joe-Laptop.home>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 27, 2009 at 12:00:46PM -0700, Joe Perches wrote:
> On Sun, 2009-09-27 at 12:45 +0200, Ingo Oeser wrote:
> > Hi Joe,
> 
> Hello Ingo.
> 
> > On Sunday 27 September 2009, Joe Perches wrote:
> > > UUID/GUIDs are somewhat common in kernel source.
> > > Standardize the printed style of UUID/GUIDs by using
> > > another extension to %p.
> > > %pU:    01020304:0506:0708:090a:0b0c0d0e0f10
> > > %pUr:   04030201:0605:0807:0a09:0b0c0d0e0f10
> > Code does "01020304-0506-0708-090a-0b0c0d0e0f10".
> > This is not, what commit promises. Please change the commit message!
> 
> True enough, that can change, no worries.
> 
> Does anyone have comments like:
> 
> 1 what a stupid idea
> 2 how unnecessary
> 3 meh
> 4 bloat alert! linux is supposed to be lean
> 5 ok idea, bad implementation
> 6 sure, why not

Sure, why not :)

