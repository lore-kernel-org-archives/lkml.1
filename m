Return-Path: <linux-kernel-owner+w=401wt.eu-S932122AbXBKThm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932122AbXBKThm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Feb 2007 14:37:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932126AbXBKThm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Feb 2007 14:37:42 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:51455 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932122AbXBKThl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Feb 2007 14:37:41 -0500
Date: Sun, 11 Feb 2007 20:37:29 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Daniel Barkalow <barkalow@iabervon.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, nigel@nigel.suspend2.net,
       Robert Hancock <hancockr@shaw.ca>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Jeff Garzik <jeff@garzik.org>, pm list <linux-pm@lists.osdl.org>
Subject: Re: [PATCH] Re: NAK new drivers without proper power management?
Message-ID: <20070211193729.GB15445@elf.ucw.cz>
References: <fa.xSKPgY66Q+DPCZ1pszFFfdrJ0To@ifi.uio.no> <200702101034.04410.rjw@sisk.pl> <1171101723.3821.22.camel@nigel.suspend2.net> <200702101130.44471.rjw@sisk.pl> <Pine.LNX.4.64.0702101231281.20138@iabervon.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0702101231281.20138@iabervon.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > Also, I think there are quite some drivers already in the tree that don't
> > support suspend/resume explicitly and honestly we should start from adding the
> > suspend/resume routines to these drivers _before_ we ban new drivers like that.
> 
> It'd be relatively quick to modify all the current drivers that don't 
> explicitly support suspend/resume to explicitly not support it. (Or

Well, I think that is more work than you realize, but yes, that patch
would really be welcome.
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
