Return-Path: <linux-kernel-owner+w=401wt.eu-S1755242AbZHCPUd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755242AbZHCPUd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 11:20:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755217AbZHCPUc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 11:20:32 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:42165 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755096AbZHCPUb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 11:20:31 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [Bug #13813] Hangups in n_tty_read()
Date: Mon, 3 Aug 2009 17:20:59 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.31-rc5-rjw; KDE/4.2.4; x86_64; ; )
Cc: =?utf-8?q?Fr=C3=A9d=C3=A9ric_Weisbecker?= <fweisbec@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
References: <Su1q3S6JjyO.A.jeB.hcgdKB@chimera> <c62985530908021815s547ac3aavb0d7a70c683ae79b@mail.gmail.com> <20090803092029.GA2163@cmpxchg.org>
In-Reply-To: <20090803092029.GA2163@cmpxchg.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200908031721.00102.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 03 August 2009, Johannes Weiner wrote:
> On Mon, Aug 03, 2009 at 03:15:10AM +0200, Frédéric Weisbecker wrote:
> > 2009/8/2 Rafael J. Wysocki <rjw@sisk.pl>:
> > > This message has been generated automatically as a part of a report
> > > of recent regressions.
> > >
> > > The following bug entry is on the current list of known regressions
> > > from 2.6.30.  Please verify if it still should be listed and let me know
> > > (either way).
> > >
> > >
> > > Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=13813
> > > Subject         : Hangups in n_tty_read()
> > > Submitter       : Johannes Weiner <hannes@cmpxchg.org>
> > > Date            : 2009-07-16 18:48 (18 days old)
> > > References      : http://marc.info/?l=linux-kernel&m=124777019920579&w=4
> > 
> > 
> > Johannes,
> > 
> > Does it still happen with latest mainline?
> > Also, could you send us your .config ?
> 
> I wanted to wait until confirming this as this bug could take a while
> to trigger.
> 
> But v2.6.31-rc4-405-gb592972 seems to be okay, I have it running
> stable for several days now.

Thanks, closed.

Rafael
