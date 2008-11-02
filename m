Return-Path: <linux-kernel-owner+w=401wt.eu-S1754758AbYKBVbf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754758AbYKBVbf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2008 16:31:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754121AbYKBVb0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Nov 2008 16:31:26 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:37037 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754001AbYKBVbZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2008 16:31:25 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Vegard Nossum" <vegard.nossum@gmail.com>
Subject: Re: [Bug #11854] v2.6.28-rc1: readlink /proc/*/exe returns uninitialized data to userspace
Date: Sun, 2 Nov 2008 22:36:02 +0100
User-Agent: KMail/1.9.9
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Kernel Testers List" <kernel-testers@vger.kernel.org>
References: <603i_OdVYPF.A.7_D.mjeDJB@chimera> <wOAXuecskPD.A.dhG.lkeDJB@chimera> <19f34abd0811021309u341b0512x2220720176011e78@mail.gmail.com>
In-Reply-To: <19f34abd0811021309u341b0512x2220720176011e78@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811022236.02781.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 2 of November 2008, Vegard Nossum wrote:
> On Sun, Nov 2, 2008 at 5:07 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > This message has been generated automatically as a part of a report
> > of recent regressions.
> >
> > The following bug entry is on the current list of known regressions
> > from 2.6.27.  Please verify if it still should be listed and let me know
> > (either way).
> >
> >
> > Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=11854
> > Subject         : v2.6.28-rc1: readlink /proc/*/exe returns uninitialized data to userspace
> > Submitter       : Vegard Nossum <vegard.nossum@gmail.com>
> > Date            : 2008-10-25 17:14 (9 days old)
> > References      : http://marc.info/?l=linux-kernel&m=122495490201663&w=4
> 
> Been trying to reproduce this one since I saw it, and I think it can
> be written off as can't reproduce :-(

Done.

Thanks,
Rafael

