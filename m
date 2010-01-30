Return-Path: <linux-kernel-owner+w=401wt.eu-S1754072Ab0A3Tz4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754072Ab0A3Tz4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jan 2010 14:55:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753104Ab0A3Tzz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jan 2010 14:55:55 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57336 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752275Ab0A3Tzz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jan 2010 14:55:55 -0500
Date: Sat, 30 Jan 2010 11:54:55 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>
cc: Kevin Winchester <kjwinchester@gmail.com>, Dave Airlie <airlied@linux.ie>,
       dri-devel <dri-devel@lists.sf.net>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Alex Deucher <alexdeucher@gmail.com>,
       Jerome Glisse <jglisse@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: Radeon KMS regression still present in 2.6.33-rc6
In-Reply-To: <201001302050.11897.johannes.hirte@fem.tu-ilmenau.de>
Message-ID: <alpine.LFD.2.00.1001301153390.4206@localhost.localdomain>
References: <1264871899.1533.6.camel@localhost.localdomain> <alpine.LFD.2.00.1001300929260.4206@localhost.localdomain> <201001302050.11897.johannes.hirte@fem.tu-ilmenau.de>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 30 Jan 2010, Johannes Hirte wrote:
> 
> This is caused by commit 42590a75019a50012f25a962246498dead42843
> 
> Fix is already posted:
> 
> http://marc.info/?l=linux-kernel&m=126428141429200&w=2

Goodie. Kevin, can you test the patch from FUJITA Tomonori in that thread 
("http://marc.info/?l=linux-kernel&m=126439631307219&w=2" to be exact).

		Linus
