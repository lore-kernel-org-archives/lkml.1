Return-Path: <linux-kernel-owner+w=401wt.eu-S1761447AbZDGVXU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761447AbZDGVXU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 17:23:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759944AbZDGVXF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 17:23:05 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:55972 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758873AbZDGVXB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 17:23:01 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Subject: Re: [Bug #13015] pppoe over ethernet
Date: Tue, 7 Apr 2009 23:23:24 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.29-rjw; KDE/4.2.2; x86_64; ; )
Cc: Detlef Tschirschky <detlef.tschirschky@gmx.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
References: <n4io5wq70ZO.A.gzG.rFn2JB@chimera> <alpine.LNX.2.00.0904071020380.7197@speedy.coe.org> <aa79d98a0904070141r45d752dana00cebb381b72c4c@mail.gmail.com>
In-Reply-To: <aa79d98a0904070141r45d752dana00cebb381b72c4c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904072323.25277.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 07 April 2009, Cyrill Gorcunov wrote:
> On 4/7/09, Detlef Tschirschky <detlef.tschirschky@gmx.de> wrote:
> > On Tue, 7 Apr 2009, Cyrill Gorcunov wrote:
> >
> >> On 4/6/09, Rafael J. Wysocki wrote:
> >
> >>> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13015
> >>> Subject	: pppoe over ethernet
> >
> >> I expect the issue is inspered by network problem found in plain
> >> 2.6.29. Detlef could you confirm the problem is still active in
> >> 2.6.29.1 or in current -git mainline?
> >
> > Moin Cyrill,
> >
> > 2.6.29.1 is running fine for me. Can't find any network problems in
> > 2.6.29.1 now.
> >
> > Thanks and regards
> >
> > Detlef
> >
> >
> Thanks a lot, Detlef!
> Rafael, i guess we could close the bug.

OK, closed.

Thanks,
Rafael
