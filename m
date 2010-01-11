Return-Path: <linux-kernel-owner+w=401wt.eu-S1754183Ab0AKUGY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754183Ab0AKUGY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 15:06:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754151Ab0AKUGK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 15:06:10 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:35049 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754045Ab0AKUGI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 15:06:08 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Borislav Petkov <petkovbb@googlemail.com>
Subject: Re: [Bug #14949] drm_vm.c:drm_mmap: possible circular locking dependency detected
Date: Mon, 11 Jan 2010 21:06:44 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.33-rc3-rjw; KDE/4.3.3; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       DRI <dri-devel@lists.sourceforge.net>
References: <wnS54-l8PVO.A.TlF.oMlSLB@chimera> <omZ8aBZReyD.A.NSH.MNlSLB@chimera> <20100111061114.GB19865@liondog.tnic>
In-Reply-To: <20100111061114.GB19865@liondog.tnic>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201001112106.44155.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 11 January 2010, Borislav Petkov wrote:
> On Sun, Jan 10, 2010 at 11:32:56PM +0100, Rafael J. Wysocki wrote:
> > This message has been generated automatically as a part of a report
> > of recent regressions.
> > 
> > The following bug entry is on the current list of known regressions
> > from 2.6.32.  Please verify if it still should be listed and let me know
> > (either way).
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14949
> > Subject		: drm_vm.c:drm_mmap: possible circular locking dependency detected
> > Submitter	: Borislav Petkov <petkovbb@googlemail.com>
> > Date		: 2009-12-26 9:45 (16 days old)
> > References	: http://marc.info/?l=linux-kernel&m=126182073616279&w=4
> 
> Fix for that is at LKML-Reference: <m1y6kh30pi.fsf_-_@fess.ebiederm.org>

Again, I don't know how to resolve that, sorry.

Rafael
