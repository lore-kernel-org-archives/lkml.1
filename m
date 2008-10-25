Return-Path: <linux-kernel-owner+w=401wt.eu-S1756552AbYJYXK5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756552AbYJYXK5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Oct 2008 19:10:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756119AbYJYXJG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Oct 2008 19:09:06 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:52307 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756059AbYJYXJE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Oct 2008 19:09:04 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Tilman Schmidt <tilman@imap.cc>
Subject: Re: [Bug #11833] 2.6.27-git8 compile error in drivers/mfd/wm8350-core.c
Date: Sun, 26 Oct 2008 01:13:35 +0200
User-Agent: KMail/1.9.9
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
References: <nw2Y6lk-0lG.A.VUB.RV5AJB@chimera> <t1C3RWL0r7M.A.rkC.xV5AJB@chimera> <4903A598.7020706@imap.cc>
In-Reply-To: <4903A598.7020706@imap.cc>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810260113.35856.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 26 of October 2008, Tilman Schmidt wrote:
> Rafael J. Wysocki schrieb:
> > The following bug entry is on the current list of known regressions
> > from 2.6.27.  Please verify if it still should be listed and let me know
> > (either way).
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11833
> > Subject		: 2.6.27-git8 compile error in drivers/mfd/wm8350-core.c
> > Submitter	: Tilman Schmidt <tilman@imap.cc>
> > Date		: 2008-10-19 18:17 (7 days old)
> > References	: http://marc.info/?l=linux-kernel&m=122444027920472&w=4
> 
> Fixed in 2.6.28-rc1 by commit c7752351c34d852ca0da697f812534101eecd82e:
> mfd: Don't use NO_IRQ in WM8350

Thanks, closed.

Rafael
