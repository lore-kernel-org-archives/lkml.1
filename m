Return-Path: <linux-kernel-owner+w=401wt.eu-S1758777AbZBEQNY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758777AbZBEQNY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 11:13:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752417AbZBEQNO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 11:13:14 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:53536 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752023AbZBEQNN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 11:13:13 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Eric Sesterhenn <snakebyte@gmx.de>
Subject: Re: [Bug #12605] Suspend regression, hang after matroxfb
Date: Thu, 5 Feb 2009 17:12:55 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc2-tst; KDE/4.2.0; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
References: <kkuKoQJIW-D.A.61C.auYiJB@chimera> <pWZw1SZjMCH.A.2UE.zuYiJB@chimera> <20090205121624.GA17811@alice>
In-Reply-To: <20090205121624.GA17811@alice>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902051712.56407.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 05 February 2009, Eric Sesterhenn wrote:
> * Rafael J. Wysocki (rjw@sisk.pl) wrote:
> > This message has been generated automatically as a part of a report
> > of recent regressions.
> > 
> > The following bug entry is on the current list of known regressions
> > from 2.6.28.  Please verify if it still should be listed and let me know
> > (either way).
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12605
> > Subject		: Suspend regression, hang after matroxfb
> > Submitter	: Eric Sesterhenn <snakebyte@gmx.de>
> > Date		: 2009-01-29 12:58 (7 days old)
> > References	: http://thread.gmane.org/gmane.linux.power-management.general/12640
> > Handled-By	: Rafael J. Wysocki <rjw@sisk.pl>
> > Patch		: http://marc.info/?l=linux-kernel&m=123335902122029&w=4
> 
> with todays -git I still get the same error, I have seen that some of 
> your PM patches got applied, seems the one I need wasnt one of them.

No, it's not been merged yet.

Thanks,
Rafael
