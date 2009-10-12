Return-Path: <linux-kernel-owner+w=401wt.eu-S1758455AbZJLV3X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758455AbZJLV3X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 17:29:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758442AbZJLV3V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 17:29:21 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:36196 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758402AbZJLV3K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 17:29:10 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Chuck Ebbert <cebbert@redhat.com>
Subject: Re: [Bug #14143] OOPS when setting nr_requests for md devices
Date: Mon, 12 Oct 2009 23:30:14 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.32-rc3-rjw; KDE/4.3.1; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "aCaB" <acab@clamav.net>
References: <56acieJJ2fF.A.nEB.Hzl0KB@chimera> <L6tb-VyKHZK.A.0sD.N0l0KB@chimera> <20091012102124.2b574d21@katamari.usersys.redhat.com>
In-Reply-To: <20091012102124.2b574d21@katamari.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200910122330.14089.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 12 October 2009, Chuck Ebbert wrote:
> On Mon, 12 Oct 2009 01:01:05 +0200 (CEST)
> "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> 
> > This message has been generated automatically as a part of a report
> > of regressions introduced between 2.6.30 and 2.6.31.
> > 
> > The following bug entry is on the current list of known regressions
> > introduced between 2.6.30 and 2.6.31.  Please verify if it still should
> > be listed and let me know (either way).
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14143
> > Subject		: OOPS when setting nr_requests for md devices
> > Submitter	: aCaB <acab@clamav.net>
> > Date		: 2009-09-08 08:48 (34 days old)
> > 
> 
> Fixed in 2.6.32 by commit b8a9ae77 ("block: don't assume device has a
> request list backing in nr_requests store")
> 
> Also in 2.6.31.1

Thanks, closing.

Rafael
