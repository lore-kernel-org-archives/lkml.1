Return-Path: <linux-kernel-owner+w=401wt.eu-S1753133AbXKRVab@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753133AbXKRVab (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Nov 2007 16:30:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751802AbXKRVaX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Nov 2007 16:30:23 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:45800 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751612AbXKRVaW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Nov 2007 16:30:22 -0500
Date: Sun, 18 Nov 2007 22:32:03 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Rob Landley <rob@landley.net>
Cc: Jeff Dike <jdike@addtoit.com>, Greg KH <greg@kroah.com>,
       WANG Cong <xiyou.wangcong@gmail.com>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, Chris Wright <chrisw@sous-sol.org>
Subject: Re: [Patch] Fix UML broken (was Re: User Mode Linux still broken in 2.6.23.1)
Message-ID: <20071118213203.GA5696@uranus.ravnborg.org>
References: <200711032351.52977.rob@landley.net> <200711161600.23745.rob@landley.net> <20071117185357.GC8206@c2.user-mode-linux.org> <200711181417.50745.rob@landley.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200711181417.50745.rob@landley.net>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 18, 2007 at 02:17:49PM -0600, Rob Landley wrote:
> On Saturday 17 November 2007 12:53:57 Jeff Dike wrote:
> > On Fri, Nov 16, 2007 at 04:00:22PM -0600, Rob Landley wrote:
> > > I wasn't cc'd, and missed it.  I'd like to test this, do you have a
> > > link?  (Or a bit more specificity than "a few weeks ago"?)
> >
> > Here are the three patches:
> >
> > 	http://marc.info/?l=linux-arch&m=119342916329510&w=2
> 
> Doesn't contain a patch.

Took me one minute to locate PATCH 1 + 2:
http://marc.info/?l=linux-arch&m=119342916429513&w=2
http://marc.info/?l=linux-arch&m=119342916229500&w=2

Maybe this helps you.

	Sam
