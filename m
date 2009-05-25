Return-Path: <linux-kernel-owner+w=401wt.eu-S1755528AbZEYXTY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755528AbZEYXTY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 19:19:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754517AbZEYXTQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 19:19:16 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:41309 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752920AbZEYXTQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 19:19:16 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [Bug #13126] BUG: MAX_LOCKDEP_ENTRIES too low! when mounting rootfs
Date: Tue, 26 May 2009 01:19:37 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc6-rjw; KDE/4.2.3; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Alexander Beregalov <a.beregalov@gmail.com>,
       Philip Copeland <bryce@zeniv.linux.org.uk>
References: <ZPPBiNHr1LC.A.9ZH.K9bGKB@chimera> <uSztiUhmDDC.A.I2B.y-bGKB@chimera> <1243239718.26820.647.camel@twins>
In-Reply-To: <1243239718.26820.647.camel@twins>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905260119.38144.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 25 May 2009, Peter Zijlstra wrote:
> On Sun, 2009-05-24 at 21:11 +0200, Rafael J. Wysocki wrote:
> > This message has been generated automatically as a part of a report
> > of recent regressions.
> > 
> > The following bug entry is on the current list of known regressions
> > from 2.6.29.  Please verify if it still should be listed and let me know
> > (either way).
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13126
> > Subject		: BUG: MAX_LOCKDEP_ENTRIES too low! when mounting rootfs
> > Submitter	: Alexander Beregalov <a.beregalov@gmail.com>
> > Date		: 2009-04-15 12:43 (40 days old)
> > References	: http://marc.info/?l=linux-kernel&m=123979949820538&w=4
> 
> -rc7 includes:
> 
> Ingo Molnar (1):
>       lockdep: increase MAX_LOCKDEP_ENTRIES and MAX_LOCKDEP_CHAINS
> 
> Which can be found with commit id: 
>    d80c19df5fcceb8c741e96f09f275c2da719efef

Thanks, closed.

Rafael
