Return-Path: <linux-kernel-owner+w=401wt.eu-S932381AbZDAOnT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932381AbZDAOnT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 10:43:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762487AbZDAOnB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 10:43:01 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:49599 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761730AbZDAOnA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 10:43:00 -0400
Date: Wed, 1 Apr 2009 16:42:41 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jan Beulich <jbeulich@novell.com>
Cc: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [RESEND][PATCH -tip] x86: smarten /proc/interrupts output for
	newcounters
Message-ID: <20090401144241.GA6196@elte.hu>
References: <49D1CC84.2020102@jp.fujitsu.com> <49D1EB87.76E4.0078.0@novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49D1EB87.76E4.0078.0@novell.com>
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


* Jan Beulich <jbeulich@novell.com> wrote:

> Acked-by: Jan Beulich <jbeulich@novell.com>

Thanks, we can apply this one once -tip merges latest -git.
(which is any day now)

	Ingo
