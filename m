Return-Path: <linux-kernel-owner+w=401wt.eu-S1756554AbZFGVEm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756554AbZFGVEm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jun 2009 17:04:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756384AbZFGVEe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Jun 2009 17:04:34 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:59811 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756098AbZFGVEe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jun 2009 17:04:34 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Trond Myklebust <trond.myklebust@fys.uio.no>
Subject: Re: [Bug #13330] nfs4 NULL pointer dereference in _nfs4_do_setlk
Date: Sun, 7 Jun 2009 23:04:41 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc8-rjw; KDE/4.2.4; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Rich Ercolani <rercola@acm.jhu.edu>
References: <bCxQpon4SCJ.A.RrF.yY7KKB@chimera> <D9VoutSOyXP.A.YjH.5Z7KKB@chimera> <1244402928.5278.7.camel@heimdal.trondhjem.org>
In-Reply-To: <1244402928.5278.7.camel@heimdal.trondhjem.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906072304.42213.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 07 June 2009, Trond Myklebust wrote:
> On Sun, 2009-06-07 at 11:52 +0200, Rafael J. Wysocki wrote:
> > This message has been generated automatically as a part of a report
> > of recent regressions.
> > 
> > The following bug entry is on the current list of known regressions
> > from 2.6.29.  Please verify if it still should be listed and let me know
> > (either way).
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13330
> > Subject		: nfs4 NULL pointer dereference in _nfs4_do_setlk
> > Submitter	: Rich Ercolani <rercola@acm.jhu.edu>
> > Date		: 2009-05-17 04:44 (22 days old)
> > Handled-By	: Trond Myklebust <trond.myklebust@fys.uio.no>
> 
> It should still be listed. I do believe I've finally identified the
> cause, and have provided a patch, however that fix has not yet been
> verified by Rich...

OK, thanks for the update.

Best,
Rafael
