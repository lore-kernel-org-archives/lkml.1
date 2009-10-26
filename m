Return-Path: <linux-kernel-owner+w=401wt.eu-S1754507AbZJZWOH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754507AbZJZWOH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 18:14:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754384AbZJZWOG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 18:14:06 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:60852 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754019AbZJZWOE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 18:14:04 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Egon Alter <egon.alter@gmx.net>
Subject: Re: [Bug #14479] nfs oops
Date: Mon, 26 Oct 2009 23:16:04 +0100
User-Agent: KMail/1.12.1 (Linux/2.6.32-rc5-rjw; KDE/4.3.1; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Frans Pop" <elendil@planet.nl>,
       "Trond Myklebust" <trond.myklebust@fys.uio.no>
References: <Sj-rRjx6TwF.A.djE.vqe5KB@chimera> <6dRYo8ss7vL.A.VJF.7qe5KB@chimera> <200910262207.30953.egon.alter@gmx.net>
In-Reply-To: <200910262207.30953.egon.alter@gmx.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <200910262316.04676.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 26 October 2009, Egon Alter wrote:
> Am Montag, 26. Oktober 2009 19:55:59 schrieb Rafael J. Wysocki:
> > This message has been generated automatically as a part of a report
> > of recent regressions.
> > 
> > The following bug entry is on the current list of known regressions
> > from 2.6.31.  Please verify if it still should be listed and let me know
> > (either way).
> >
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14479
> > Subject		: nfs oops
> > Submitter	: Egon Alter <egon.alter@gmx.net>
> > Date		: 2009-10-19 16:03 (8 days old)
> > References	: http://marc.info/?l=linux-kernel&m=125596822630410&w=4 
> 
> I cannot reproduce this anymore with lastest git (with or without the patch 
> from Trond). So it is in a closeable state. Will reopen when it reappears.

Thanks, closing.

Rafael
