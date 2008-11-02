Return-Path: <linux-kernel-owner+w=401wt.eu-S1754411AbYKBXvI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754411AbYKBXvI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2008 18:51:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753755AbYKBXuz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Nov 2008 18:50:55 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:37523 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753914AbYKBXuy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2008 18:50:54 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Carlos R. Mafra" <crmafra2@gmail.com>
Subject: Re: [Bug #11845] Suspend regression on Lenovo x60
Date: Mon, 3 Nov 2008 00:55:22 +0100
User-Agent: KMail/1.9.9
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>, Tomas Winkler <tomasw@gmail.com>
References: <603i_OdVYPF.A.7_D.mjeDJB@chimera> <wOAXuecskPD.A.3LH.0keDJB@chimera> <20081102220758.GA14374@localhost.aei.mpg.de>
In-Reply-To: <20081102220758.GA14374@localhost.aei.mpg.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811030055.22645.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 2 of November 2008, Carlos R. Mafra wrote:
> On Sun  2.Nov'08 at 17:07:01 +0100, Rafael J. Wysocki wrote:
> > This message has been generated automatically as a part of a report
> > of recent regressions.
> > 
> > The following bug entry is on the current list of known regressions
> > from 2.6.27.  Please verify if it still should be listed and let me know
> > (either way).
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11845
> > Subject		: Suspend regression on Lenovo x60
> > Submitter	: Jens Axboe <jens.axboe@oracle.com>
> > Date		: 2008-10-24 18:02 (10 days old)
> > References	: http://marc.info/?l=linux-next&m=122487159829507&w=4
> > 		  http://marc.info/?l=linux-kernel&m=122512449714310&w=4
> > Handled-By	: Rafael J. Wysocki <rjw@sisk.pl>
> > 		  Tomas Winkler <tomasw@gmail.com>
> > Patch		: http://marc.info/?l=linux-kernel&m=122513311900482&w=4
> > 		  http://marc.info/?l=linux-wireless&m=122518625308673&w=4
> 
> It is fixed by commit 10d0bd56966571d0324dfd9bbb8aa913a60bef5f which
> is now in Linus' tree.

Thanks, closed.

Rafael
