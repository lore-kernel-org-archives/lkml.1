Return-Path: <linux-kernel-owner+w=401wt.eu-S1754409AbYHLTzz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754409AbYHLTzz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 15:55:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752166AbYHLTzq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 15:55:46 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:34386 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751968AbYHLTzp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 15:55:45 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Eric Sesterhenn <snakebyte@gmx.de>
Subject: Re: [Bug #11274] Oops when accessing /proc/lockdep_chains
Date: Tue, 12 Aug 2008 21:58:45 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Rabin Vincent <rabin@rab.in>, Adrian Bunk <bunk@kernel.org>
References: <VYYCiQF4qDI.A.BPH.KCjnIB@albercik> <cX_-nNkxKaF.A.Ks.8CjnIB@albercik> <20080812171635.GA18689@alice>
In-Reply-To: <20080812171635.GA18689@alice>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808122158.45971.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 12 of August 2008, Eric Sesterhenn wrote:
> * Rafael J. Wysocki (rjw@sisk.pl) wrote:
> > This message has been generated automatically as a part of a report
> > of recent regressions.
> > 
> > The following bug entry is on the current list of known regressions
> > from 2.6.26.  Please verify if it still should be listed and let me know
> > (either way).
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11274
> > Subject		: Oops when accessing /proc/lockdep_chains
> > Submitter	: Eric Sesterhenn <snakebyte@gmx.de>
> > Date		: 2008-08-06 12:16 (4 days old)
> > References	: http://marc.info/?l=linux-kernel&m=121802509626294&w=4
> > Handled-By	: Rabin Vincent <rabin@rab.in>
> > Patch		: http://marc.info/?l=linux-kernel&m=121814269607276&w=4
> 
> the patch went into linus -git today, you can close this.

Thanks, Adrian has already closed the bug.

Rafael
