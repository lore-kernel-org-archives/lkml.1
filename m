Return-Path: <linux-kernel-owner+w=401wt.eu-S1754051Ab0AKTx0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754051Ab0AKTx0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 14:53:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753946Ab0AKTxZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 14:53:25 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:34939 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753892Ab0AKTxY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 14:53:24 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Robert Hancock <hancockrwd@gmail.com>
Subject: Re: [Bug #14922] 2.6.32 seemed to have broken nVidia MCP7A sata controller
Date: Mon, 11 Jan 2010 20:54:00 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.33-rc3-rjw; KDE/4.3.3; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Jeff Garzik <jeff@garzik.org>, Mike Cui <cuicui@gmail.com>
References: <nzLqtSp97aP.A.RGB.hglSLB@chimera> <CXIfLt-ygXM.A.-sB.uglSLB@chimera> <51f3faa71001101517i10bde693n51688e2bd8c411b8@mail.gmail.com>
In-Reply-To: <51f3faa71001101517i10bde693n51688e2bd8c411b8@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201001112054.00259.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 11 January 2010, Robert Hancock wrote:
> On Sun, Jan 10, 2010 at 4:56 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
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
> > Date            : 2009-12-19 6:13 (23 days old)
> > References      : http://marc.info/?l=linux-ide&m=126120323407742&w=4
> > Handled-By      : Jeff Garzik <jeff@garzik.org>
> >                  Robert Hancock <hancockrwd@gmail.com>
> 
> Still outstanding. Waiting for testing results from the reporter with
> that drive on another AHCI controller, if possible. I CCed Peer Chen
> from NVIDIA on the Bugzilla report, maybe they know if there is some
> known problem with FPDMA AA on that controller.

Thanks for the update.

Rafael
