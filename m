Return-Path: <linux-kernel-owner+w=401wt.eu-S1760593AbYARMdw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760593AbYARMdw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 07:33:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755520AbYARMdo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 07:33:44 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:56823 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754769AbYARMdn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 07:33:43 -0500
Date: Fri, 18 Jan 2008 13:33:24 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Andi Kleen <ak@suse.de>, Jan Beulich <jbeulich@novell.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH]  x86: fold _PAGE_GLOBAL into __PAGE_KERNEL
Message-ID: <20080118123324.GJ11044@elte.hu>
References: <478FAC91.90109@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <478FAC91.90109@goop.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-0.5 required=5.9 tests=BAYES_20 autolearn=no SpamAssassin version=3.2.3
	-0.5 BAYES_20               BODY: Bayesian spam probability is 5 to 20%
	[score: 0.0669]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> With the iounmap problem resolved, it should be OK to always set 
> _PAGE_GLOBAL in __PAGE_KERNEL*.

thanks Jeremy, applied.

> [ Did this patch cause problems before? ]

not that i remember.

	Ingo
