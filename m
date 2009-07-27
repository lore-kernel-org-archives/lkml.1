Return-Path: <linux-kernel-owner+w=401wt.eu-S1755509AbZG0BOp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755509AbZG0BOp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jul 2009 21:14:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754701AbZG0BOo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Jul 2009 21:14:44 -0400
Received: from mx2.redhat.com ([66.187.237.31]:43776 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754674AbZG0BOo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jul 2009 21:14:44 -0400
Date: Sun, 26 Jul 2009 21:14:00 -0400
From: Jeff Layton <jlayton@redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Steve French <sfrench@us.ibm.com>
Subject: Re: [Patch RFC 20/37] cifs: convert semaphore to mutex
Message-ID: <20090726211400.14f52dd2@tupile.poochiereds.net>
In-Reply-To: <20090726081555.873287270@linutronix.de>
References: <20090726081459.455111897@linutronix.de>
	<20090726081555.873287270@linutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 26 Jul 2009 08:18:39 -0000
Thomas Gleixner <tglx@linutronix.de> wrote:

> pSesInfo->sesSem is used as mutex so make it a mutex.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Cc: Steve French <sfrench@us.ibm.com>

Acked-by: Jeff Layton <jlayton@redhat.com>
