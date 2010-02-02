Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756205Ab0BBUwq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 15:52:46 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:36380 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753696Ab0BBUwo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 15:52:44 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Robert Hancock <hancockrwd@gmail.com>
Subject: Re: [Bug #14922] 2.6.32 seemed to have broken nVidia MCP7A sata controller
Date: Tue, 2 Feb 2010 21:53:30 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.33-rc6-rjw; KDE/4.3.5; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Jeff Garzik <jeff@garzik.org>, Mike Cui <cuicui@gmail.com>
References: <UgwvXSBS_tM.A.alD.1EiZLB@chimera> <de962C6zBxL.A.AMF.tFiZLB@chimera> <51f3faa71001311713sf4dbd45w240003a77de24f68@mail.gmail.com>
In-Reply-To: <51f3faa71001311713sf4dbd45w240003a77de24f68@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201002022153.31025.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 01 February 2010, Robert Hancock wrote:
> On Sun, Jan 31, 2010 at 6:43 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > This message has been generated automatically as a part of a report
> > of regressions introduced between 2.6.31 and 2.6.32.
> >
> > The following bug entry is on the current list of known regressions
> > introduced between 2.6.31 and 2.6.32.  Please verify if it still should
> > be listed and let me know (either way).
> >
> >
> > Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=14922
> > Subject         : 2.6.32 seemed to have broken nVidia MCP7A sata controller
> > Submitter       : Mike Cui <cuicui@gmail.com>
> > Date            : 2009-12-19 6:13 (44 days old)
> > References      : http://marc.info/?l=linux-ide&m=126120323407742&w=4
> > Handled-By      : Jeff Garzik <jeff@garzik.org>
> >                  Robert Hancock <hancockrwd@gmail.com>
> 
> Still outstanding. I posted a patch that should fix the problem,
> waiting for feedback from the reporter.

Thanks for the update.

Rafael
