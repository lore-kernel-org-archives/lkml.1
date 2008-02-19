Return-Path: <linux-kernel-owner+w=401wt.eu-S1754420AbYBSLzj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754420AbYBSLzj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 06:55:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750982AbYBSLzb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 06:55:31 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:52809 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750727AbYBSLza (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 06:55:30 -0500
Date: Tue, 19 Feb 2008 12:55:37 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Greg KH <greg@kroah.com>, kkeil@suse.de, isdn4linux@listserv.isdn4linux.de,
       linux-kernel@vger.kernel.org, Jeff Garzik <jeff@garzik.org>
Subject: Re: Plans for mISDN? Was: [PATCH 00/14] [ISDN] ...
Message-ID: <20080219115537.GB5604@uranus.ravnborg.org>
References: <098123kjff90231nv098233rnvd908u234@garzik.org> <20080217195235.GN14588@uranus.ravnborg.org> <20080218045209.GA15141@kroah.com> <p73zltyxy9q.fsf@bingen.suse.de> <20080219085033.GA1775@uranus.ravnborg.org> <20080219094034.GD6485@one.firstfloor.org> <20080219095622.GC4164@uranus.ravnborg.org> <20080219095834.GB6940@one.firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080219095834.GB6940@one.firstfloor.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> I'm not sure either it's a good idea to try to merge mISDN if the
> maintainers don't think it is ready yet.

In the spirit of relase early - relase often we should at
least see what is going on.

And Gregory wrote:
> ive been hackin away at mISDN for a while and use it with recent kernels
>  2.6.2X and have a patch for 2.6.24 (move from semaphore to complition)
> the distro we built is heavily reliant on mISDN (voip) i dont use the
> isdn kernel drivers at all any longer.
So not useless and having it in the kernel may cause more people
to contribute.
I for one do prefer to hack on something in the kernel and
not hidden in some repository far away.

But until we see patches lets wait and see.

	Sam
