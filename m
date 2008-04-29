Return-Path: <linux-kernel-owner+w=401wt.eu-S1756535AbYD2Mc3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756535AbYD2Mc3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 08:32:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752989AbYD2McU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 08:32:20 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:44110 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752370AbYD2McT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 08:32:19 -0400
Date: Tue, 29 Apr 2008 14:32:02 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Olof Johansson <olof@lixom.net>, Andrew Morton <akpm@linux-foundation.org>,
       "David S. Miller" <davem@davemloft.net>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH/resend] 2.6.25+: Fix cpu hotplug problem in softirq code
Message-ID: <20080429123202.GI31271@elte.hu>
References: <200804242113.11602.borntraeger@de.ibm.com> <200804290940.12838.borntraeger@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200804290940.12838.borntraeger@de.ibm.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Christian Borntraeger <borntraeger@de.ibm.com> wrote:

> This is a resend of a patch, which fixes a bug in cpu hotplug 
> introduced after 2.6.25. Andrew, Olof, any opinions on this patch?

hm, nice catch.

  Acked-by: Ingo Molnar <mingo@elte.hu>

	Ingo
