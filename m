Return-Path: <linux-kernel-owner+w=401wt.eu-S1752194AbZDVGVS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752194AbZDVGVS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 02:21:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750870AbZDVGVF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 02:21:05 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:41423 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750751AbZDVGVE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 02:21:04 -0400
Date: Wed, 22 Apr 2009 08:20:53 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linus 2.6.30-rc3
Message-ID: <20090422062053.GA20960@elte.hu>
References: <alpine.LFD.2.00.0904212014170.3101@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alpine.LFD.2.00.0904212014170.3101@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


A last-minute build error slipped through:

  In file included from fs/compat_ioctl.c:105:
  include/linux/pktcdvd.h:285: error: expected specifier-qualifier-list before ‘mempool_t’

	Ingo
