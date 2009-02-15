Return-Path: <linux-kernel-owner+w=401wt.eu-S1753506AbZBOO1l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753506AbZBOO1l (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Feb 2009 09:27:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751260AbZBOO1c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Feb 2009 09:27:32 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:46836 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751229AbZBOO1b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Feb 2009 09:27:31 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Adrian McMenamin <lkmladrian@gmail.com>
Subject: Re: [Bug #12502] pipe_read oops on sh
Date: Sun, 15 Feb 2009 15:27:12 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc5-tst; KDE/4.2.0; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
References: <juADNmcceYF.A.mdD.Mr0lJB@chimera> <rjPbZ5GRJPO.A.E3F.xs0lJB@chimera> <8b67d60902141623k449dc769n9fd6bf180d3267d3@mail.gmail.com>
In-Reply-To: <8b67d60902141623k449dc769n9fd6bf180d3267d3@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902151527.12627.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 15 February 2009, Adrian McMenamin wrote:
> 2009/2/14 Rafael J. Wysocki <rjw@sisk.pl>:
> > This message has been generated automatically as a part of a report
> > of recent regressions.
> >
> > The following bug entry is on the current list of known regressions
> > from 2.6.28.  Please verify if it still should be listed and let me know
> > (either way).
> >
> >
> > Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=12502
> > Subject         : pipe_read oops on sh
> > Submitter       : Adrian McMenamin <lkmladrian@gmail.com>
> > Date            : 2009-01-15 9:48 (31 days old)
> > References      : http://marc.info/?l=linux-kernel&m=123201298005600&w=4
> >
> >
> >
> 
> No, it was caused by a race condition that has now been fixed.

Thanks, bug closed.

Rafael
