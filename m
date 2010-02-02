Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756122Ab0BBUpw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 15:45:52 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:36345 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753696Ab0BBUpu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 15:45:50 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Borislav Petkov <petkovbb@googlemail.com>
Subject: Re: [Bug #14949] drm_vm.c:drm_mmap: possible circular locking dependency detected
Date: Tue, 2 Feb 2010 21:46:45 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.33-rc6-rjw; KDE/4.3.5; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       DRI <dri-devel@lists.sourceforge.net>,
       "Eric W. Biederman" <ebiederm@aristanetworks.com>
References: <vZZJKzCUn4G.A.CPB.F7hZLB@chimera> <d3IDKWHT5gE.A.DLD.q8hZLB@chimera> <9ea470501002011001s7734a20ft4dd5d181baf714c3@mail.gmail.com>
In-Reply-To: <9ea470501002011001s7734a20ft4dd5d181baf714c3@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201002022146.45078.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 01 February 2010, Borislav Petkov wrote:
> On Mon, Feb 1, 2010 at 1:22 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > This message has been generated automatically as a part of a report
> > of recent regressions.
> >
> > The following bug entry is on the current list of known regressions
> > from 2.6.32.  Please verify if it still should be listed and let me know
> > (either way).
> >
> >
> > Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=14949
> > Subject         : drm_vm.c:drm_mmap: possible circular locking dependency detected
> > Submitter       : Borislav Petkov <petkovbb@googlemail.com>
> > Date            : 2009-12-26 9:45 (37 days old)
> > References      : http://marc.info/?l=linux-kernel&m=126182073616279&w=4
> > Handled-By      : Eric W. Biederman <ebiederm@aristanetworks.com>
> > Patch           : http://patchwork.kernel.org/patch/70461/
> 
> Yes, this is fixed.

Do you mean "fixed" as "the fix is in the Linus' tree" or "fixed" as "the
patch fixed it for me"?

Rafael
