Return-Path: <linux-kernel-owner+w=401wt.eu-S1761930AbZBEBoT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761930AbZBEBoT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 20:44:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754975AbZBEBoD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 20:44:03 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:49494 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753070AbZBEBoB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 20:44:01 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrey Borzenkov <arvidjaar@mail.ru>
Subject: Re: [Bug #12606] fb_mmap: circular locking dependency on hibernation
Date: Thu, 5 Feb 2009 02:43:42 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc2-tst; KDE/4.2.0; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
References: <kkuKoQJIW-D.A.61C.auYiJB@chimera> <pWZw1SZjMCH.A.jNE.xuYiJB@chimera> <200902041743.08010.arvidjaar@mail.ru>
In-Reply-To: <200902041743.08010.arvidjaar@mail.ru>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902050243.43440.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 04 February 2009, Andrey Borzenkov wrote:
> On 4 of February 2009 13:24:06 Rafael J. Wysocki wrote:
> > This message has been generated automatically as a part of a report
> > of recent regressions.
> >
> > The following bug entry is on the current list of known regressions
> > from 2.6.28.  Please verify if it still should be listed and let me
> > know (either way).
> >
> >
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12606
> > Subject		: fb_mmap: circular locking dependency on hibernation
> > Submitter	: Andrey Borzenkov <arvidjaar@mail.ru>
> > Date		: 2009-01-27 18:37 (9 days old)
> > References	: http://marc.info/?l=linux-kernel&m=123308162731408&w=4
> 
> for me it is fixed with
> http://marc.info/?l=linux-kernel&m=123365581406194&w=2 

Thanks, I've updated the bug entry.

Rafael
