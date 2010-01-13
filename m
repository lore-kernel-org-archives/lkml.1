Return-Path: <linux-kernel-owner+w=401wt.eu-S1756514Ab0AMVyA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756514Ab0AMVyA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 16:54:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756460Ab0AMVx7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 16:53:59 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:48943 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751346Ab0AMVx6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 16:53:58 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: =?utf-8?q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
Subject: Re: [Bug #14903] Kernel panic - not syncing: Attempted to kill init!
Date: Wed, 13 Jan 2010 22:54:39 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.33-rc3-rjw; KDE/4.3.3; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Zhiyong Wu <zwu.kernel@gmail.com>
References: <nzLqtSp97aP.A.RGB.hglSLB@chimera> <CXIfLt-ygXM.A.zyB.vglSLB@chimera> <2375c9f91001121855j2884e594nd6f9801231c1bb83@mail.gmail.com>
In-Reply-To: <2375c9f91001121855j2884e594nd6f9801231c1bb83@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201001132254.39976.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 13 January 2010, Américo Wang wrote:
> On Mon, Jan 11, 2010 at 6:56 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > This message has been generated automatically as a part of a report
> > of regressions introduced between 2.6.31 and 2.6.32.
> >
> > The following bug entry is on the current list of known regressions
> > introduced between 2.6.31 and 2.6.32.  Please verify if it still should
> > be listed and let me know (either way).
> >
> >
> > Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=14903
> > Subject         : Kernel panic - not syncing: Attempted to kill init!
> > Submitter       : Zhiyong Wu <zwu.kernel@gmail.com>
> > Date            : 2009-12-18 4:08 (24 days old)
> > References      : http://marc.info/?l=linux-kernel&m=126110931124738&w=4
> > Handled-By      : Américo Wang <xiyou.wangcong@gmail.com>
> >
> 
> Hi,
> 
> I don't think this is a kernel problem, it should be a problem of Zhiyong's
> initrd, or Zhiyong may not configure his kernel properly, in any case,
> this is not a bug of kernel.

Thanks, closing.

Rafael
