Return-Path: <linux-kernel-owner+w=401wt.eu-S1756192AbZAMATk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756192AbZAMATk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 19:19:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753130AbZAMAT3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 19:19:29 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:46740 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752158AbZAMAT2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 19:19:28 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Justin Madru <jdm64@gawab.com>
Subject: Re: [Bug #12263] Sata soft reset filling log
Date: Tue, 13 Jan 2009 01:18:50 +0100
User-Agent: KMail/1.10.3 (Linux/2.6.29-rc1-rjw; KDE/4.1.3; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Linux IDE <linux-ide@vger.kernel.org>
References: <nn3SOLVZ28H.A.bY.CafaJB@chimera> <nHCfeC0YLrE.A.tiC.4afaJB@chimera> <496BD7ED.1010909@gawab.com>
In-Reply-To: <496BD7ED.1010909@gawab.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901130118.50674.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 13 January 2009, Justin Madru wrote:
> Rafael J. Wysocki wrote:
> > This message has been generated automatically as a part of a report
> > of regressions introduced between 2.6.27 and 2.6.28.
> >
> > The following bug entry is on the current list of known regressions
> > introduced between 2.6.27 and 2.6.28.  Please verify if it still should
> > be listed and let me know (either way).
> >
> >
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12263
> > Subject		: Sata soft reset filling log
> > Submitter	: Justin Madru <bevicm@dslextreme.com>
> > Date		: 2008-12-13 2:07 (30 days old)
> > References	: http://marc.info/?l=linux-kernel&m=122913412608533&w=4
> >
> >
> >
> >   
> Yes, I'm still seeing this on .28 and even on .29-rc1.
> I checked again and couldn't trigger the regression on a .27 kernel (at 
> least with my hardware and config).
> So, I'm fairly confident that it's a regression, not just a bug that's 
> always been there.

Thanks for the update.

Rafael
