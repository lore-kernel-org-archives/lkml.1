Return-Path: <linux-kernel-owner+w=401wt.eu-S1754789AbZALIAu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754789AbZALIAu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 03:00:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751958AbZALIAl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 03:00:41 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:39904 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751605AbZALIAk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 03:00:40 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Caleb Cushing" <xenoterracide@gmail.com>
Subject: Re: [Bug #12264] i915: switching from kwin in opengl mode to a VT then back to x11, x11 freezes
Date: Mon, 12 Jan 2009 09:00:20 +0100
User-Agent: KMail/1.10.3 (Linux/2.6.28-rjw; KDE/4.1.3; x86_64; ; )
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Kernel Testers List" <kernel-testers@vger.kernel.org>
References: <nn3SOLVZ28H.A.bY.CafaJB@chimera> <nHCfeC0YLrE.A.ncC.2afaJB@chimera> <81bfc67a0901111642i37f46edar8592899d7193b863@mail.gmail.com>
In-Reply-To: <81bfc67a0901111642i37f46edar8592899d7193b863@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901120900.20446.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 12 January 2009, Caleb Cushing wrote:
> so far I'm tracking with gentoo here.
> http://bugs.gentoo.org/show_bug.cgi?id=253813 and freedesktop here
> http://bugs.freedesktop.org/process_bug.cgi
> 
> and I've tested the first 2 kernel patches alone, and still have the
> issue, haven't been able to add the libdrm patch to libdrm so far.

Thanks for the update.

Rafael


> On 1/11/09, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > This message has been generated automatically as a part of a report
> >  of regressions introduced between 2.6.27 and 2.6.28.
> >
> >  The following bug entry is on the current list of known regressions
> >  introduced between 2.6.27 and 2.6.28.  Please verify if it still should
> >  be listed and let me know (either way).
> >
> >
> >  Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=12264
> >  Subject         : i915: switching from kwin in opengl mode to a VT then back to x11, x11 freezes
> >  Submitter       : Caleb Cushing <xenoterracide@gmail.com>
> >  Date            : 2008-12-16 11:40 (27 days old)
> >  References      : http://marc.info/?l=linux-kernel&m=122942777030666&w=4
