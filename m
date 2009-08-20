Return-Path: <linux-kernel-owner+w=401wt.eu-S1755484AbZHTV2l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755484AbZHTV2l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 17:28:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755406AbZHTV2k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 17:28:40 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:39491 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754930AbZHTV2k convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 17:28:40 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Bruno =?utf-8?q?Pr=C3=A9mont?= <bonbons@linux-vserver.org>
Subject: Re: [Bug #13942] Troubles with AoE and uninitialized object
Date: Thu, 20 Aug 2009 23:29:33 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.31-rc6-rjw; KDE/4.3.0; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
References: <jCYznkTxcLB.A.EPH.eNIjKB@chimera> <ADSuNT6McuD.A.1t.BOIjKB@chimera> <20090820212959.0ece42e3@neptune.home>
In-Reply-To: <20090820212959.0ece42e3@neptune.home>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <200908202329.33695.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 20 August 2009, Bruno Prémont wrote:
> On Wed, 19 August 2009 "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> > This message has been generated automatically as a part of a report
> > of recent regressions.
> > 
> > The following bug entry is on the current list of known regressions
> > from 2.6.30.  Please verify if it still should be listed and let me
> > know (either way).
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13942
> > Subject		: Troubles with AoE and uninitialized object
> > Submitter	: Bruno Prémont <bonbons@linux-vserver.org>
> > Date		: 2009-08-04 10:12 (16 days old)
> > References	:
> > http://marc.info/?l=linux-kernel&m=124938117104811&w=4
> > 
> 
> This one is still valid for 2.6.31-rc6 though I have not yet taken
> the time to attempt bisecting it. I will probably bisect over the
> week-end.

Thanks for the update.

Rafael
