Return-Path: <linux-kernel-owner+w=401wt.eu-S932776AbYBVMWy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932776AbYBVMWy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 07:22:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756763AbYBVMWn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 07:22:43 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:4938 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755046AbYBVMWl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 07:22:41 -0500
Date: Sun, 17 Feb 2008 15:51:56 +0000
From: Pavel Machek <pavel@ucw.cz>
To: David Miller <davem@davemloft.net>
Cc: sam@ravnborg.org, greg@kroah.com, torvalds@linux-foundation.org,
       jeff@garzik.org, arjan@infradead.org, sfr@canb.auug.org.au,
       linux-kernel@vger.kernel.org, linux-next@vger.kernel.org,
       linux-arch@vger.kernel.org, akpm@linux-foundation.org,
       linux-kbuild@vger.kernel.org
Subject: Re: distributed module configuration
Message-ID: <20080217155155.GA3940@ucw.cz>
References: <20080212191552.GA20883@kroah.com> <20080212.164149.209357519.davem@davemloft.net> <20080213084541.GA8091@uranus.ravnborg.org> <20080213.005433.23276743.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080213.005433.23276743.davem@davemloft.net>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > Does this fit what you had in mind?
> 
> Yes it does.
> 
> Now I'll ask if you think embedding this information in one of the C
> files for a module would be even nicer?

I kind of like to be able to grep over just Kconfig files, to find out
what is going on...
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
