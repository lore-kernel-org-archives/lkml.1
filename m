Return-Path: <linux-kernel-owner+w=401wt.eu-S1756259AbZLUBLZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756259AbZLUBLZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Dec 2009 20:11:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753677AbZLUBLY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Dec 2009 20:11:24 -0500
Received: from mail.perches.com ([173.55.12.10]:1353 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752095AbZLUBLX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Dec 2009 20:11:23 -0500
Subject: Re: [tip:sched/urgent] sched: Restore printk sanity
From: Joe Perches <joe@perches.com>
To: tytso@mit.edu
Cc: Ingo Molnar <mingo@elte.hu>, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       peterz@infradead.org, efault@gmx.de, akpm@linux-foundation.org,
       tglx@linutronix.de, linux-tip-commits@vger.kernel.org
In-Reply-To: <20091220221232.GC4887@thunk.org>
References: <1261315437.4314.6.camel@laptop>
	 <tip-3df0fc5b2e9d8092dcaeb5ae0b6753d85c851d66@git.kernel.org>
	 <1261335300.30458.209.camel@Joe-Laptop.home>
	 <20091220191531.GA17878@elte.hu>  <20091220221232.GC4887@thunk.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 20 Dec 2009 17:11:21 -0800
Message-ID: <1261357881.30458.235.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-12-20 at 17:12 -0500, tytso@mit.edu wrote:
> Maybe all
> printk's should be exempted from this, or at least if it's the format
> string which is breaking whatever the magic boundary happens to be?

If ever Andy Whitcroft gets 'round to releasing the
latest checkpatch from testing, the formats of
logging functions are exempted from long line checks.


