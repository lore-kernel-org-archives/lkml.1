Return-Path: <linux-kernel-owner+w=401wt.eu-S1760726AbYDOIPs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760726AbYDOIPs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 04:15:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754675AbYDOIPg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 04:15:36 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:34027 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754404AbYDOIPf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 04:15:35 -0400
Date: Tue, 15 Apr 2008 10:15:16 +0200
From: Ingo Molnar <mingo@elte.hu>
To: yhlu.kernel@gmail.com
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <clameter@sgi.com>,
       kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86_64/mm: check and print vmemmap allocation
	continuous -fix
Message-ID: <20080415081516.GA19452@elte.hu>
References: <200804120119.24868.yhlu.kernel@gmail.com> <20080414235348.a5ddffee.akpm@linux-foundation.org> <200804150111.21990.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200804150111.21990.yhlu.kernel@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: 0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.5 required=5.9 tests=BAYES_40 autolearn=no SpamAssassin version=3.2.3
	0.5 BAYES_40               BODY: Bayesian spam probability is 20 to 40%
	[score: 0.2250]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


thanks Yinghai, applied.

	Ingo
