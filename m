Return-Path: <linux-kernel-owner+w=401wt.eu-S1754151Ab0AKUKN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754151Ab0AKUKN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 15:10:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754080Ab0AKUKL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 15:10:11 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:35073 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754045Ab0AKUKK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 15:10:10 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Marc Dionne <marc.c.dionne@gmail.com>
Subject: Re: [Bug #15037] BUG during shutdown - bisected to commit e2912009
Date: Mon, 11 Jan 2010 21:10:46 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.33-rc3-rjw; KDE/4.3.3; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Xiaotian Feng <dfeng@redhat.com>, Mike Galbraith <efault@gmx.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
References: <wnS54-l8PVO.A.TlF.oMlSLB@chimera> <omZ8aBZReyD.A.0FG.xMlSLB@chimera> <6041d2001001110512p58e84103n53cf3729b28a5313@mail.gmail.com>
In-Reply-To: <6041d2001001110512p58e84103n53cf3729b28a5313@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201001112110.46837.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 11 January 2010, Marc Dionne wrote:
> On Sun, Jan 10, 2010 at 5:32 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > This message has been generated automatically as a part of a report
> > of recent regressions.
> >
> > The following bug entry is on the current list of known regressions
> > from 2.6.32.  Please verify if it still should be listed and let me know
> > (either way).
> >
> >
> > Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=15037
> > Subject         : BUG during shutdown - bisected to commit e2912009
> > Submitter       : Marc Dionne <marc.c.dionne@gmail.com>
> > Date            : 2010-01-02 0:27 (9 days old)
> > References      : http://marc.info/?l=linux-kernel&m=126239207631034&w=4
> > Handled-By      : Xiaotian Feng <dfeng@redhat.com>
> > Patch           : http://patchwork.kernel.org/patch/71537/
> 
> I verified that the BUG still occurs with current git.
> The referenced patch does fix the issue for me, but it hasn't made its
> way into mainline yet.

Thanks for the update.

Rafael
