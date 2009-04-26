Return-Path: <linux-kernel-owner+w=401wt.eu-S1756368AbZDZRqk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756368AbZDZRqk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Apr 2009 13:46:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754398AbZDZRq3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Apr 2009 13:46:29 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:45006 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753394AbZDZRq2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Apr 2009 13:46:28 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alexander Beregalov <a.beregalov@gmail.com>
Subject: Re: [Bug #13124] ioatdma: DMA-API: device driver frees DMA memory with wrong function
Date: Sun, 26 Apr 2009 19:46:24 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc3-rjw; KDE/4.2.2; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Dan Williams <dan.j.williams@intel.com>
References: <47KgT3nlbjD.A.lnB.jc48JB@chimera> <Fg2zLW93smL.A.qeD.Md48JB@chimera> <a4423d670904260906y3db7e256g371185ec31717054@mail.gmail.com>
In-Reply-To: <a4423d670904260906y3db7e256g371185ec31717054@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904261946.25380.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 26 April 2009, Alexander Beregalov wrote:
> 2009/4/25 Rafael J. Wysocki <rjw@sisk.pl>:
> > This message has been generated automatically as a part of a report
> > of recent regressions.
> >
> > The following bug entry is on the current list of known regressions
> > from 2.6.29.  Please verify if it still should be listed and let me know
> > (either way).
> >
> >
> > Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=13124
> > Subject         : ioatdma: DMA-API: device driver frees DMA memory with wrong function
> > Submitter       : Alexander Beregalov <a.beregalov@gmail.com>
> > Date            : 2009-04-09 12:36 (17 days old)
> > References      : http://marc.info/?l=linux-kernel&m=123928064322503&w=4
> > Handled-By      : Dan Williams <dan.j.williams@intel.com>
> 
> Patch is available, http://patchwork.kernel.org/patch/19621/

Thanks for the update.

Rafael
