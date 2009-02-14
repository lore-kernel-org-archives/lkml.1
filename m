Return-Path: <linux-kernel-owner+w=401wt.eu-S1754593AbZBNWjY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754593AbZBNWjY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Feb 2009 17:39:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752619AbZBNWjQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Feb 2009 17:39:16 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:44373 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752553AbZBNWjP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Feb 2009 17:39:15 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: wixor <wixorpeek@gmail.com>
Subject: Re: [Bug #12664] viafb triggers BUG at mm/vmalloc.c:294
Date: Sat, 14 Feb 2009 23:39:03 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc5-tst; KDE/4.2.0; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Alexey Dobriyan <adobriyan@gmail.com>
References: <AIghyjFgMFP.A.uZD._10jJB@chimera> <sWhNs83kKPE.A.7EE.O20jJB@chimera> <c43b2e150902090217p6efe5141q4b3a608a00c02f71@mail.gmail.com>
In-Reply-To: <c43b2e150902090217p6efe5141q4b3a608a00c02f71@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902142339.04283.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 09 February 2009, wixor wrote:
> There was no support for Chrome9 framebuffer before 2.6.28, so that is
> a progress. However now that we have it, it doesn't work (at least for
> me).... The BUG appearing seemed to be an mm-issue also reported by
> others (see http://marc.info/?l=linux-kernel&m=123415925903748&w=2). I
> don't know if it was there before 2.6.28. It doesn't look like any
> solution has been merged to mainline.
> 
> It is certainly an issue, but I'm not sure if it's also a regression
> from 2.6.28.

I've dropped it from the list of recent regressions, sorry for the slow
response.

Thanks,
Rafael
