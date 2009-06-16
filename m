Return-Path: <linux-kernel-owner+w=401wt.eu-S1759825AbZFPPWd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759825AbZFPPWd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 11:22:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757798AbZFPPW0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 11:22:26 -0400
Received: from mailhost19.gawab.com ([66.220.20.19]:50942 "HELO
	info33.gawab.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757768AbZFPPWZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 11:22:25 -0400
X-Trusted: Whitelisted
From: Al Boldi <a1426z@gawab.com>
To: Greg KH <gregkh@suse.de>
Subject: Re: Linux 2.6.29.5
Date: Tue, 16 Jun 2009 18:02:43 +0300
User-Agent: KMail/1.5
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org
References: <20090615200304.GA2003@kroah.com> <200906160733.57322.a1426z@gawab.com> <20090616051415.GA30708@suse.de>
In-Reply-To: <20090616051415.GA30708@suse.de>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200906161802.43349.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> On Tue, Jun 16, 2009 at 07:33:57AM +0300, Al Boldi wrote:
> > > > It may be a good idea to also allow pulling patches over email.
> > >
> > > I'm confused as to why you would want this.  kernel.org is mirrored all
> > > around the world, so the tree can be found through ftp and http
> > > everywhere.
> >
> > Sometimes the only ports open are 110 and 25.
>
> That would not sound like an environment in which kernel development can
> happen very easily.
>
> > > > Majordomo has such a facility via the "index" and "get" commands.
> > >
> > > Majordomo is not used here for email delivery.
> >
> > Strange, vger.kernel.org sends via majordomo.
>
> For subscribing to lists only, not for email delivery.

Right, so the infrastructure is in place to support pulling patches via email 
by simply sending the line "get linux-kernel patch-2.6.29.5.bz2" in
the body of a message to majordomo@vger.kernel.org.

All that is needed now is to populate those dirs.


Thanks!

--
Al
