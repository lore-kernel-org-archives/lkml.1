Return-Path: <linux-kernel-owner+w=401wt.eu-S1757991AbZCCWmm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757991AbZCCWmm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 17:42:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755907AbZCCWmd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 17:42:33 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:39860 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753418AbZCCWmc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 17:42:32 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Michael S. Tsirkin" <m.s.tsirkin@gmail.com>
Subject: Re: [Bug #12574] possible circular locking dependency detected
Date: Tue, 3 Mar 2009 23:42:36 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc5-tst; KDE/4.2.0; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
References: <KiHv0irKPzE.A.l3.hUarJB@chimera> <SLCXkuHtxAO.A.LtE.VWarJB@chimera> <8f53421d0903031419m493b88bbifa911323279f4f0b@mail.gmail.com>
In-Reply-To: <8f53421d0903031419m493b88bbifa911323279f4f0b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903032342.36851.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 03 March 2009, Michael S. Tsirkin wrote:
> On Tue, Mar 3, 2009 at 9:25 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > This message has been generated automatically as a part of a report
> > of recent regressions.
> >
> > The following bug entry is on the current list of known regressions
> > from 2.6.28.  Please verify if it still should be listed and let me know
> > (either way).
> >
> >
> > Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=12574
> > Subject         : possible circular locking dependency detected
> > Submitter       : Michael S. Tsirkin <m.s.tsirkin@gmail.com>
> > Date            : 2009-01-29 11:35 (34 days old)
> > References      : http://lkml.org/lkml/2009/2/9/205
> >
> >
> >
> 
> I don't seem to observe this warning in v2.6.29-rc6 anymore.

OK, I'm going to close it, then.

Thanks,
Rafael
