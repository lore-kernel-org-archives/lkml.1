Return-Path: <linux-kernel-owner+w=401wt.eu-S1755587AbYKDJRs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755587AbYKDJRs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 04:17:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753912AbYKDJRb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 04:17:31 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:55511 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753587AbYKDJRa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 04:17:30 -0500
Date: Tue, 4 Nov 2008 10:16:52 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Gary Hade <garyhade@us.ibm.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Yasunori Goto <y-goto@jp.fujitsu.com>,
       Badari Pulavarty <pbadari@us.ibm.com>, Mel Gorman <mel@csn.ul.ie>,
       Chris McDermott <lcm@us.ibm.com>, Greg KH <greg@kroah.com>,
       Dave Hansen <dave@linux.vnet.ibm.com>,
       Nish Aravamudan <nish.aravamudan@gmail.com>
Subject: Re: [PATCH] [REPOST #2] mm: show node to memory section
	relationship with symlinks in sysfs
Message-ID: <20081104091652.GH23790@elte.hu>
References: <20081103234808.GA13716@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081103234808.GA13716@us.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Gary Hade <garyhade@us.ibm.com> wrote:

> Show node to memory section relationship with symlinks in sysfs

nice change.

>  arch/x86/mm/init_32.c                          |    2 
>  arch/x86/mm/init_64.c                          |    2 

Acked-by: Ingo Molnar <mingo@elte.hu>

	Ingo
