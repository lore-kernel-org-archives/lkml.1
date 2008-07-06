Return-Path: <linux-kernel-owner+w=401wt.eu-S1759834AbYGFV6S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759834AbYGFV6S (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2008 17:58:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755934AbYGFV6F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jul 2008 17:58:05 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:56461 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755511AbYGFV6D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2008 17:58:03 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: 2.6.26-rc9: Reported regressions from 2.6.25
Date: Mon, 7 Jul 2008 00:00:12 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
References: <Vu1KV8Wj_GP.A.qW.DzLcIB@albercik> <alpine.LFD.1.10.0807061453340.3016@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0807061453340.3016@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807070000.13178.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 6 of July 2008, Linus Torvalds wrote:
> 
> On Sun, 6 Jul 2008, Rafael J. Wysocki wrote:
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11041
> > Subject		: All 2.6.26-rcX hang immediately after loading ohci_hcd
> > Submitter	: Andrey Borzenkov <arvidjaar@mail.ru>
> > Date		: 2008-07-05 7:08 (2 days old)
> > References	: http://marc.info/?l=linux-kernel&m=121524504505805&w=4
> > Handled-By	: Linus Torvalds <torvalds@linux-foundation.org>
> 
> The revert that was confirmed by Andrey to fix this regression is now 
> committed as 09ca8adbe9f724a7e96f512c0039c4c4a1c5dcc0.

Thanks, I have closed the bug.

Rafael
