Return-Path: <linux-kernel-owner+w=401wt.eu-S1755081AbZCZLN6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755081AbZCZLN6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 07:13:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751503AbZCZLNu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 07:13:50 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:46056 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751075AbZCZLNu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 07:13:50 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18891.25448.953379.813652@cargo.ozlabs.ibm.com>
Date: Thu, 26 Mar 2009 22:13:44 +1100
From: Paul Mackerras <paulus@samba.org>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       linux-kernel@vger.kernel.org, Mike Galbraith <efault@gmx.de>,
       Arjan van de Ven <arjan@infradead.org>,
       Wu Fengguang <fengguang.wu@intel.com>
Subject: Re: [RFC][PATCH 2/3] perf_counter: executable mmap() information
In-Reply-To: <18891.24450.489196.961004@cargo.ozlabs.ibm.com>
References: <20090325210419.408653980@chello.nl>
	<20090325210542.293237509@chello.nl>
	<18891.6159.109191.255560@drongo.ozlabs.ibm.com>
	<20090326100058.GD19826@elte.hu>
	<18891.24450.489196.961004@cargo.ozlabs.ibm.com>
X-Mailer: VM 8.0.9 under Emacs 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I wrote:

> Fair enough, but as it stands, we've changed the ABI, so we need to
> fix it.

I meant of course that that patch would change the ABI if it were
accepted...

Paul.
