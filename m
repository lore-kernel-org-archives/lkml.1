Return-Path: <linux-kernel-owner+w=401wt.eu-S1756096Ab0A0Vnx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756096Ab0A0Vnx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 16:43:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755122Ab0A0Vnw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 16:43:52 -0500
Received: from casper.infradead.org ([85.118.1.10]:35304 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753403Ab0A0Vnw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 16:43:52 -0500
Subject: Re: [tip:sched/urgent] sched: cpuacct: Use bigger percpu counter 
 batch values for stats counters
From: Peter Zijlstra <peterz@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>, mingo@redhat.com, hpa@zytor.com,
       anton@samba.org, linux-kernel@vger.kernel.org, tglx@linutronix.de,
       mingo@elte.hu, linux-tip-commits@vger.kernel.org
In-Reply-To: <20100127132212.cd43cd94.akpm@linux-foundation.org>
References: <20100118044142.GS12666@kryten>
	 <tip-43f85eab1411905afe5db510fbf9841b516e7e6a@git.kernel.org>
	 <661de9471001270534ve6f7bf0nb58ef58f9a6ff10e@mail.gmail.com>
	 <20100127132212.cd43cd94.akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 27 Jan 2010 22:43:20 +0100
Message-ID: <1264628600.4283.2080.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-01-27 at 13:22 -0800, Andrew Morton wrote:

> Last I heard, Anton was "working on a useful comment" and will be
> redoing the patch.

If Anton is working on a new version, would Anton then also care to post
one that compiles on UP? :-)

