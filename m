Return-Path: <linux-kernel-owner+w=401wt.eu-S1752289AbZLIIw6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752289AbZLIIw6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 03:52:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752235AbZLIIw4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 03:52:56 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:37474 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752224AbZLIIwy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 03:52:54 -0500
Date: Wed, 9 Dec 2009 09:52:24 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Micha? Miros?aw <mirq-linux@rere.qmqm.pl>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org
Subject: Re: [PATCH 3/7] mtrr: Remove use_intel()
Message-ID: <20091209085224.GB5129@elte.hu>
References: <1-1000-25639-1260344705-9533@rere.qmqm.pl>
 <4-1000-25639-1260344705-9533@rere.qmqm.pl>
 <86802c440912090010q3aa9c701u75fbba19d43308e0@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440912090010q3aa9c701u75fbba19d43308e0@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Yinghai Lu <yhlu.kernel@gmail.com> wrote:

> can you check it with amd64 cpu?

do you have a suspicion that it might be broken?

	Ingo
