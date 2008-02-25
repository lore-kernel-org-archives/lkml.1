Return-Path: <linux-kernel-owner+w=401wt.eu-S1755710AbYBYOhf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755710AbYBYOhf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 09:37:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753578AbYBYOh1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 09:37:27 -0500
Received: from mail.gmx.net ([213.165.64.20]:33828 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751448AbYBYOh0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 09:37:26 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18SWqABStYSzvy9wakwBVgoHqEypJce6cg22TlAT/
	cQph0hsIxfevO9
Subject: Re: [PATCH] sched: revert load_balance_monitor()
From: Mike Galbraith <efault@gmx.de>
To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20080225143518.GA29275@linux.vnet.ibm.com>
References: <1203942167.6242.142.camel@lappy>
	 <1203949799.4688.9.camel@homer.simson.net>
	 <20080225143518.GA29275@linux.vnet.ibm.com>
Content-Type: text/plain
Date: Mon, 25 Feb 2008 15:37:12 +0100
Message-Id: <1203950233.4688.11.camel@homer.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2008-02-25 at 20:05 +0530, Dhaval Giani wrote:

> This is funny. The thread should not start. Did the full revert that I
> sent you sometime back work better?

Yes.

	-Mike

