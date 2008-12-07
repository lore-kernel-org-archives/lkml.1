Return-Path: <linux-kernel-owner+w=401wt.eu-S1753481AbYLGUNa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753481AbYLGUNa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2008 15:13:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751099AbYLGUNV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Dec 2008 15:13:21 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:34509 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750846AbYLGUNU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2008 15:13:20 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Frederik <mailinglists.fredi@gmail.com>
Subject: Re: [Bug #12161] [i915 drm] irq 16: nobody cared with latest git kernels
Date: Sun, 7 Dec 2008 21:12:51 +0100
User-Agent: KMail/1.9.9
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
References: <QFIA5HSHV8B.A.2aG.hoxNJB@chimera> <bfPM5B8Tx2B.A.SrG.ooxNJB@chimera> <200812072016.35510.mailinglists.fredi@gmail.com>
In-Reply-To: <200812072016.35510.mailinglists.fredi@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812072112.51317.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 7 of December 2008, Frederik wrote:
> Hi Rafael,
> On Wednesday 03 December 2008 22:58:06 Rafael J. Wysocki wrote:
> > This message has been generated automatically as a part of a report
> > of recent regressions.
> >
> > The following bug entry is on the current list of known regressions
> > from 2.6.27.  Please verify if it still should be listed and let me know
> > (either way).
> 
> This regression is present on kernels newer than 2.4.28-rc3. Unfortunately it 
> needs time to hit this bug so there's no easy way to bisect it ... And BTW 
> there is a bugzilla entry here for this issue: 
> 
> https://bugs.freedesktop.org/show_bug.cgi?id=18609

Thanks, I added the reference to the bug entry.

Rafael
