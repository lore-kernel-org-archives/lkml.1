Return-Path: <linux-kernel-owner+w=401wt.eu-S1756248AbZKQTTV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756248AbZKQTTV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 14:19:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754610AbZKQTTU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 14:19:20 -0500
Received: from mail.perches.com ([173.55.12.10]:1095 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753587AbZKQTTT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 14:19:19 -0500
Date: Tue, 17 Nov 2009 11:19:13 -0800 (PST)
From: Joe Perches <joe@mail.perches.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: =?ISO-8859-15?Q?Uwe_Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
       <linux-kernel@vger.kernel.org>, Michael Buesch <mb@bu3sch.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] strcmp: fix overflow error
In-Reply-To: <alpine.LFD.2.01.0911171102210.9384@localhost.localdomain>
Message-ID: <Pine.LNX.4.30.0911171112240.8119-100000@mail.perches.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


It's been like that for awhile.

http://www.linuxhq.com/kernel/v1.1/75/lib/string.c

