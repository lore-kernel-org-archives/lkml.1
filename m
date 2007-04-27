Return-Path: <linux-kernel-owner+w=401wt.eu-S1755323AbXD0BBJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755323AbXD0BBJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 21:01:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751555AbXD0BBJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 21:01:09 -0400
Received: from mail15.syd.optusnet.com.au ([211.29.132.196]:46757 "EHLO
	mail15.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755323AbXD0BBH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 21:01:07 -0400
From: Con Kolivas <kernel@kolivas.org>
To: Gene Heskett <gene.heskett@gmail.com>
Subject: Re: [patch] CFS scheduler, -v6
Date: Fri, 27 Apr 2007 10:57:52 +1000
User-Agent: KMail/1.9.5
Cc: Redeeman <redeeman@metanurb.dk>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Mike Galbraith <efault@gmx.de>,
       Arjan van de Ven <arjan@infradead.org>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Thomas Gleixner <tglx@linutronix.de>, caglar@pardus.org.tr,
       Willy Tarreau <w@1wt.eu>, Mark Lord <lkml@rtr.ca>,
       Zach Carter <linux@zachcarter.com>, buddabrod <buddabrod@gmail.com>
References: <20070425214704.GA32572@elte.hu> <200704270848.41416.kernel@kolivas.org> <200704262039.07781.gene.heskett@gmail.com>
In-Reply-To: <200704262039.07781.gene.heskett@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704271057.53842.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 27 April 2007 10:39, Gene Heskett wrote:
> Not necessarily Con.  Do you have a fresh one for 2.6.21?

Since people get nervous about any rejects here is an (otherwise identical) 
patch for 2.6.21

http://ck.kolivas.org/patches/staircase-deadline/2.6.21-sd-0.46.patch

-- 
-ck
