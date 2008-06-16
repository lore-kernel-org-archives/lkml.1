Return-Path: <linux-kernel-owner+w=401wt.eu-S1755843AbYFPNSg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755843AbYFPNSg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 09:18:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753346AbYFPNS2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 09:18:28 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:57938 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753322AbYFPNS1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 09:18:27 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Miquel van Smoorenburg <miquels@cistron.nl>
Subject: Re: [Bug 10905] 2.6.26: x86/kernel/pci_dma.c: gfp |= __GFP_NORETRY ?
Date: Mon, 16 Jun 2008 15:19:54 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andi Kleen <andi@firstfloor.org>, Glauber Costa <gcosta@redhat.com>
References: <RzbtSgMztjP.A.R0C.dIDVIB@albercik> <Jn7irxIunJK.A.QLD.qIDVIB@albercik> <1213615582.19372.2.camel@n2o.xs4all.nl>
In-Reply-To: <1213615582.19372.2.camel@n2o.xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806161519.55161.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 16 of June 2008, Miquel van Smoorenburg wrote:
> On Sat, 2008-06-14 at 22:12 +0200, Rafael J. Wysocki wrote:
> > This message has been generated automatically as a part of a report
> > of recent regressions.
> > 
> > The following bug entry is on the current list of known regressions
> > from 2.6.25.  Please verify if it still should be listed.
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10905
> > Subject		: 2.6.26: x86/kernel/pci_dma.c: gfp |= __GFP_NORETRY ?
> > Submitter	: Miquel van Smoorenburg <miquels@cistron.nl>
> > Date		: 2008-05-21 13:30 (25 days old)
> > References	: http://lkml.org/lkml/2008/5/21/131
> > 		  http://lkml.org/lkml/2008/6/12/121
> > Handled-By	: Glauber Costa <gcosta@redhat.com>
> > 		  Andi Kleen <andi@firstfloor.org>
> > 		  Miquel van Smoorenburg <mikevs@xs4all.net>
> > Patch		: http://lkml.org/lkml/2008/5/28/42
> 
> This bug was recently fixed in 2.6.26 by commit
> 0269c5c6d9a9de22715ecda589730547435cd3e8

Thanks, closed.

Rafael
