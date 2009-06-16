Return-Path: <linux-kernel-owner+w=401wt.eu-S1756907AbZFPEdc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756907AbZFPEdc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 00:33:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750791AbZFPEdZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 00:33:25 -0400
Received: from mailhost3.gawab.com ([66.220.20.3]:56436 "HELO info8.gawab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750737AbZFPEdZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 00:33:25 -0400
X-Trusted: Whitelisted
From: Al Boldi <a1426z@gawab.com>
To: Greg KH <gregkh@suse.de>
Subject: Re: Linux 2.6.29.5
Date: Tue, 16 Jun 2009 07:33:57 +0300
User-Agent: KMail/1.5
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org
References: <20090615200304.GA2003@kroah.com> <200906160648.04627.a1426z@gawab.com> <20090616035630.GA30380@suse.de>
In-Reply-To: <20090616035630.GA30380@suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906160733.57322.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> On Tue, Jun 16, 2009 at 06:48:04AM +0300, Al Boldi wrote:
> > Greg KH wrote:
> > > I'm announcing the release of the 2.6.29.5 kernel.  All users of the
> > > 2.6.29 kernel series are very strongly encouraged to upgrade.
> > >
> > > I'll also be replying to this message with a copy of the patch between
> > > 2.6.29.4 and 2.6.29.5
> > >
> > > The updated 2.6.29.y git tree can be found at:
> > >
> > > git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.29.y.git
> > > and can be browsed at the normal kernel.org git web browser:
> > >
> > > http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.29.y.git;a=s
> > >umma
> >
> > It may be a good idea to also allow pulling patches over email.
>
> I'm confused as to why you would want this.  kernel.org is mirrored all
> around the world, so the tree can be found through ftp and http
> everywhere.

Sometimes the only ports open are 110 and 25.

> > Majordomo has such a facility via the "index" and "get" commands.
>
> Majordomo is not used here for email delivery.

Strange, vger.kernel.org sends via majordomo.


Thanks!

--
Al

