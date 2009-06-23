Return-Path: <linux-kernel-owner+w=401wt.eu-S1759997AbZFWOH7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759997AbZFWOH7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 10:07:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757780AbZFWOHs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 10:07:48 -0400
Received: from mx2.redhat.com ([66.187.237.31]:38554 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756719AbZFWOHr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 10:07:47 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20090623125832.GA6872@linux.vnet.ibm.com>
References: <20090623125832.GA6872@linux.vnet.ibm.com> <20090623042442.GA15630@linux.vnet.ibm.com> <28711.1245748358@redhat.com> <20090623093208.GD23698@elte.hu>
To: paulmck@linux.vnet.ibm.com
Cc: dhowells@redhat.com, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org, niv@us.ibm.com,
       dvhltc@us.ibm.com, lethal@linux-sh.org, kernel@wantstofly.org,
       matthew@wil.cx
Subject: Re: [PATCH] v5 RCU: the bloatwatch edition
Date: Tue, 23 Jun 2009 15:07:27 +0100
Message-ID: <6660.1245766047@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:

> I am personally OK with it being .32, as long as David Howells,
> Lennert Buytenhek, and Paul Mundt are OK with that schedule.

Whilst it might be nice to get it in .31, I don't mind it being lodged in
linux-next till .32.

David
