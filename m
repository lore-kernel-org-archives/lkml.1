Return-Path: <linux-kernel-owner+w=401wt.eu-S1753724Ab0ARPOa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753724Ab0ARPOa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 10:14:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752771Ab0ARPO3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 10:14:29 -0500
Received: from mx1.redhat.com ([209.132.183.28]:60173 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751547Ab0ARPO2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 10:14:28 -0500
Date: Mon, 18 Jan 2010 17:14:05 +0200
From: Gleb Natapov <gleb@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Pekka Enberg <penberg@cs.helsinki.fi>,
       linux-mm@kvack.org, kosaki.motohiro@jp.fujitsu.com,
       linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
       akpm@linux-foundation.org, andrew.c.morrow@gmail.com,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH v6] add MAP_UNLOCKED mmap flag
Message-ID: <20100118151405.GD14345@redhat.com>
References: <20100118133755.GG30698@redhat.com>
 <84144f021001180609r4d7fbbd0p972d5bc0e227d09a@mail.gmail.com>
 <20100118141938.GI30698@redhat.com>
 <20100118143232.0a0c4b4d@lxorguk.ukuu.org.uk>
 <1263826198.4283.600.camel@laptop>
 <20100118150159.GB14345@redhat.com>
 <1263827194.4283.609.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1263827194.4283.609.camel@laptop>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 18, 2010 at 04:06:34PM +0100, Peter Zijlstra wrote:
> On Mon, 2010-01-18 at 17:01 +0200, Gleb Natapov wrote:
> > There are valid uses for mlockall()
> 
> That's debatable.
> 
Well, I have use for it. You can look at previous thread were I described
it and suggest alternatives.

--
			Gleb.
