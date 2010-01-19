Return-Path: <linux-kernel-owner+w=401wt.eu-S1754315Ab0ASAM5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754315Ab0ASAM5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 19:12:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754213Ab0ASAMw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 19:12:52 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:59498 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753846Ab0ASAMt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 19:12:49 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Gleb Natapov <gleb@redhat.com>
Subject: Re: [PATCH v6] add MAP_UNLOCKED mmap flag
Cc: kosaki.motohiro@jp.fujitsu.com, Peter Zijlstra <peterz@infradead.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Pekka Enberg <penberg@cs.helsinki.fi>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
       akpm@linux-foundation.org, andrew.c.morrow@gmail.com,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
In-Reply-To: <20100118151405.GD14345@redhat.com>
References: <1263827194.4283.609.camel@laptop> <20100118151405.GD14345@redhat.com>
Message-Id: <20100119091004.5F28.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue, 19 Jan 2010 09:12:44 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Mon, Jan 18, 2010 at 04:06:34PM +0100, Peter Zijlstra wrote:
> > On Mon, 2010-01-18 at 17:01 +0200, Gleb Natapov wrote:
> > > There are valid uses for mlockall()
> > 
> > That's debatable.
> > 
> Well, I have use for it. You can look at previous thread were I described
> it and suggest alternatives.

Please stop suck.
This is the reviewing. The reviewers shouldn't need to look at all
previous thread. It mean your description isn't enough.



