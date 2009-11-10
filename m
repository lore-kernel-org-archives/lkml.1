Return-Path: <linux-kernel-owner+w=401wt.eu-S1757391AbZKJRTa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757391AbZKJRTa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 12:19:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757351AbZKJRTa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 12:19:30 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:47551 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757340AbZKJRT3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 12:19:29 -0500
Date: Tue, 10 Nov 2009 18:19:10 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Dimitri Sivanich <sivanich@sgi.com>
Cc: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       yinghai@kernel.org, suresh.b.siddha@intel.com, tglx@linutronix.de
Subject: Re: [tip:x86/apic] x86/apic: Limit irq affinity
Message-ID: <20091110171910.GA25581@elte.hu>
References: <20091021011233.GB32196@sgi.com>
 <tip-683c91f85d7a3e1092d7fa3ec5687af8cd379f02@git.kernel.org>
 <20091108145355.GA8432@elte.hu>
 <20091109160215.GA14718@sgi.com>
 <20091110044025.GA7897@elte.hu>
 <20091110163118.GA13707@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091110163118.GA13707@sgi.com>
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


* Dimitri Sivanich <sivanich@sgi.com> wrote:

> So it looks like we have 4 bytes more text and 128 bytes more data.

> Looks like 15 bytes text and 240 bytes data.

fair enough - and it removes a good bit of #ifdef complexity. Mind 
sending it standalone, tested, properly changelogged and with the above 
data included?

Thanks,

	Ingo
