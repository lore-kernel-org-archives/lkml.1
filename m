Return-Path: <linux-kernel-owner+w=401wt.eu-S1755448AbZKFJ7T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755448AbZKFJ7T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 04:59:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754532AbZKFJ7S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 04:59:18 -0500
Received: from [95.166.99.235] ([95.166.99.235]:56271 "EHLO kernel.dk"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752173AbZKFJ7S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 04:59:18 -0500
Date: Fri, 6 Nov 2009 10:59:22 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Tejun Heo <tj@kernel.org>, Jiri Kosina <jkosina@suse.cz>,
       Peter Zijlstra <peterz@infradead.org>,
       Yinghai Lu <yhlu.kernel@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, cl@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: irq lock inversion
Message-ID: <20091106095922.GH8742@kernel.dk>
References: <86802c440911041008q4969b9bdk15b4598c40bb84bd@mail.gmail.com> <4AF25FC7.4000502@kernel.org> <20091105082102.GA2870@elte.hu> <4AF28D7A.6020209@kernel.org> <alpine.LSU.2.00.0911051502060.9988@wotan.suse.de> <4AF3B9BD.9050300@kernel.org> <20091106071711.GA20946@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091106071711.GA20946@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 06 2009, Ingo Molnar wrote:
> Read the lockdep message please, consider all the backtraces it prints, 
> it says something different.

In all honesty, reading and parsing lockdep messages requires a special
state of mind. IOW, readability is not its high point.

-- 
Jens Axboe

