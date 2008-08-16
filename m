Return-Path: <linux-kernel-owner+w=401wt.eu-S1753020AbYHPL5j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753020AbYHPL5j (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Aug 2008 07:57:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751560AbYHPL5a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Aug 2008 07:57:30 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:35827 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751279AbYHPL53 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Aug 2008 07:57:29 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Subject: Re: [Bug #11276] build error: CONFIG_OPTIMIZE_INLINING=y causes gcc 4.2 to do stupid things
Date: Sat, 16 Aug 2008 14:00:31 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Ingo Molnar" <mingo@elte.hu>, "Randy Dunlap" <randy.dunlap@oracle.com>
References: <VYYCiQF4qDI.A.BPH.KCjnIB@albercik> <cX_-nNkxKaF.A.Fg.4CjnIB@albercik> <200808151721.08175.bjorn.helgaas@hp.com>
In-Reply-To: <200808151721.08175.bjorn.helgaas@hp.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808161400.32209.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, 16 of August 2008, Bjorn Helgaas wrote:
> On Saturday 09 August 2008 04:43:51 pm Rafael J. Wysocki wrote:
> > The following bug entry is on the current list of known regressions
> > from 2.6.26.  Please verify if it still should be listed and let me know
> > (either way).
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11276
> > Subject		: build error: CONFIG_OPTIMIZE_INLINING=y causes gcc 4.2 to do stupid things
> > Submitter	: Randy Dunlap <randy.dunlap@oracle.com>
> > Date		: 2008-08-06 17:18 (4 days old)
> > References	: http://marc.info/?l=linux-kernel&m=121804329014332&w=4
> > 		  http://lkml.org/lkml/2008/7/22/353
> > Handled-By	: Bjorn Helgaas <bjorn.helgaas@hp.com>
> > Patch		: http://lkml.org/lkml/2008/7/22/364
> 
> Since I supplied a patch, I assume I don't need to do anything more.
> Let me know if my assumption is incorrect.

You don't need to do anything more, but please let me know when the patch gets
into to Linus' tree (please ignore the subsequent "should it still be listed"
messages until that happens).

Thanks,
Rafael
