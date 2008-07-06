Return-Path: <linux-kernel-owner+w=401wt.eu-S1759423AbYGFVym@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759423AbYGFVym (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2008 17:54:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755934AbYGFVye
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jul 2008 17:54:34 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50372 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755889AbYGFVyd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2008 17:54:33 -0400
Date: Sun, 6 Jul 2008 14:54:21 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: 2.6.26-rc9: Reported regressions from 2.6.25
In-Reply-To: <Vu1KV8Wj_GP.A.qW.DzLcIB@albercik>
Message-ID: <alpine.LFD.1.10.0807061453340.3016@woody.linux-foundation.org>
References: <Vu1KV8Wj_GP.A.qW.DzLcIB@albercik>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 6 Jul 2008, Rafael J. Wysocki wrote:
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11041
> Subject		: All 2.6.26-rcX hang immediately after loading ohci_hcd
> Submitter	: Andrey Borzenkov <arvidjaar@mail.ru>
> Date		: 2008-07-05 7:08 (2 days old)
> References	: http://marc.info/?l=linux-kernel&m=121524504505805&w=4
> Handled-By	: Linus Torvalds <torvalds@linux-foundation.org>

The revert that was confirmed by Andrey to fix this regression is now 
committed as 09ca8adbe9f724a7e96f512c0039c4c4a1c5dcc0.

		Linus
