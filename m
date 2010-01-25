Return-Path: <linux-kernel-owner+w=401wt.eu-S1752902Ab0AYUqg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752902Ab0AYUqg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 15:46:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751211Ab0AYUqf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 15:46:35 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:51874 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751190Ab0AYUqe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 15:46:34 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Robert Hancock <hancockrwd@gmail.com>
Subject: Re: [Bug #14922] 2.6.32 seemed to have broken nVidia MCP7A sata controller
Date: Mon, 25 Jan 2010 21:47:25 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.33-rc4-rjw; KDE/4.3.3; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Jeff Garzik <jeff@garzik.org>, Mike Cui <cuicui@gmail.com>
References: <pYFNu11z2aM.A.pJH.CZMXLB@chimera> <q60Z28d_9yH.A.aX.kZMXLB@chimera> <51f3faa71001241825yec6e37br8032b7a3730ce840@mail.gmail.com>
In-Reply-To: <51f3faa71001241825yec6e37br8032b7a3730ce840@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201001252147.25868.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 25 January 2010, Robert Hancock wrote:
> On Sun, Jan 24, 2010 at 4:23 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
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
> > Date            : 2009-12-19 6:13 (37 days old)
> > References      : http://marc.info/?l=linux-ide&m=126120323407742&w=4
> > Handled-By      : Jeff Garzik <jeff@garzik.org>
> >                  Robert Hancock <hancockrwd@gmail.com>
> 
> It's a confirmed regression. Waiting on some lspci -nn output from the
> reporter. However, for now, disabling auto-activate optimization on
> all NVIDIA AHCIs may be the easiest option.

Thanks for the update.

Rafael
