Return-Path: <linux-kernel-owner+w=401wt.eu-S1753186AbZBCW4y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753186AbZBCW4y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 17:56:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751698AbZBCW4p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 17:56:45 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:41736 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751664AbZBCW4o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 17:56:44 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alexander Beregalov <a.beregalov@gmail.com>
Subject: Re: [Bug #12402] 2.6.29-rc: kernel BUG at fs/xfs/support/debug.c:108
Date: Tue, 3 Feb 2009 23:56:02 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc2-tst; KDE/4.2.0; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Christoph Hellwig <hch@infradead.org>,
       Eric Sandeen <sandeen@sandeen.net>, Dave Chinner <david@fromorbit.com>
References: <0GOi9pntEoL.A.iGF.B9QdJB@chimera> <2QN7KFic7LG.A.03.I-QdJB@chimera> <a4423d670901281539s958128avcaf4756021125795@mail.gmail.com>
In-Reply-To: <a4423d670901281539s958128avcaf4756021125795@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902032356.03242.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 29 January 2009, Alexander Beregalov wrote:
> 2009/1/20 Rafael J. Wysocki <rjw@sisk.pl>:
> > This message has been generated automatically as a part of a report
> > of recent regressions.
> >
> > The following bug entry is on the current list of known regressions
> > from 2.6.28.  Please verify if it still should be listed and let me know
> > (either way).
> >
> >
> > Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=12402
> > Subject         : 2.6.29-rc: kernel BUG at fs/xfs/support/debug.c:108
> > Submitter       : Alexander Beregalov <a.beregalov@gmail.com>
> > Date            : 2009-01-09 04:41 (11 days old)
> > References      : http://thread.gmane.org/gmane.comp.file-systems.xfs.general/27548
> > Handled-By      : Christoph Hellwig <hch@infradead.org>
> >
> 
> Should be closed, thanks.
> 
> commit 74e2d06521913443c7e2697037909f5efc200ec5
> (Long btree pointers are still 64 bit on disk)

Closed, thanks.

Rafael
