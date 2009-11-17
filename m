Return-Path: <linux-kernel-owner+w=401wt.eu-S1756396AbZKQWbf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756396AbZKQWbf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 17:31:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756197AbZKQWbe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 17:31:34 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:38630 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756048AbZKQWbd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 17:31:33 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andy Lutomirski <amluto@gmail.com>
Subject: Re: [Bug #14472] EXT4 corruption
Date: Tue, 17 Nov 2009 23:32:42 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.32-rc7-rjw; KDE/4.3.3; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Andy Lutomirski <luto@mit.edu>,
       "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
       Shawn Starr <shawn.starr@rogers.com>, Theodore Tso <tytso@mit.edu>
References: <GUZt44bIwCE.A.vLF.pSdALB@chimera> <xXQGFmujPl.A.EOH.XTdALB@chimera> <9872C96C-FAE8-46E8-9588-25D917AF0EAD@gmail.com>
In-Reply-To: <9872C96C-FAE8-46E8-9588-25D917AF0EAD@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200911172332.43018.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 17 November 2009, Andy Lutomirski wrote:
> I'm think this was the journal checksumming bug, which is fixed.

Thanks for the update.


> On Nov 16, 2009, at 5:37 PM, "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> 
> > This message has been generated automatically as a part of a report
> > of recent regressions.
> >
> > The following bug entry is on the current list of known regressions
> > from 2.6.31.  Please verify if it still should be listed and let me  
> > know
> > (either way).
> >
> >
> > Bug-Entry    : http://bugzilla.kernel.org/show_bug.cgi?id=14472
> > Subject        : EXT4 corruption
> > Submitter    : Shawn Starr <shawn.starr@rogers.com>
> > Date        : 2009-10-13 2:07 (35 days old)
> > References    : http://marc.info/?l=linux-kernel&m=125539997508256&w=4
> > Handled-By    : Theodore Tso <tytso@mit.edu>

I'm going to close the bug.

Rafael
