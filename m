Return-Path: <linux-kernel-owner+w=401wt.eu-S1752722AbXLDTtb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752722AbXLDTtb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 14:49:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751369AbXLDTtY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 14:49:24 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:50076 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750993AbXLDTtX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 14:49:23 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Giacomo A. Catenazzi" <cate@cateee.net>
Subject: Re: [Bug 9246] On 2.6.24-rc1-gc9927c2b BUG: unable to handle kernel paging request at virtual address 3d15b925
Date: Tue, 4 Dec 2007 21:08:14 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       bugme-daemon@bugzilla.kernel.org
References: <alpine.LFD.0.999.0710232057080.30120@woody.linux-foundation.org> <20071204100832.GA11031@elte.hu> <475584A4.6080800@cateee.net>
In-Reply-To: <475584A4.6080800@cateee.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712042108.15262.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 4 of December 2007, Giacomo A. Catenazzi wrote:
> Ingo Molnar wrote:
> > hi,
> > 
> > * Giacomo Catenazzi <cate@cateee.net> wrote:
> > 
> >> On 2.6.24-rc1-gc9927c2b BUG: unable to handle kernel paging request at 
> >> virtual address 3d15b925
> >>
> >> In last git, I see the following BUGs in various programs.  It seems 
> >> reproducible, but sometime I've hard lookup on poweroff.
> > 
> > do you still get this with more recent kernels? We had a number of fixes 
> > for memory corruptors since -rc1 - perhaps one of them took care of your 
> > problem as well.
> 
> No, the problem was solved few days after the report.

Can you point me to the fix, please?

Rafael
