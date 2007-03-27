Return-Path: <linux-kernel-owner+w=401wt.eu-S1753100AbXC0FX6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753100AbXC0FX6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 01:23:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753209AbXC0FX6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 01:23:58 -0400
Received: from mail.gmx.net ([213.165.64.20]:43891 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753100AbXC0FX5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 01:23:57 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+KkvZ1hjmKPvj0JrIwGiuV2a8lBGXLfwJub7bxI4
	za1cp6mACBIF+0
Subject: Re: [PATCH][ 3/5] sched: implement staircase deadline cpu scheduler
From: Mike Galbraith <efault@gmx.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Con Kolivas <kernel@kolivas.org>,
       linux kernel mailing list <linux-kernel@vger.kernel.org>,
       ck list <ck@vds.kolivas.org>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <20070326204723.af7203af.akpm@linux-foundation.org>
References: <200703271210.39429.kernel@kolivas.org>
	 <20070326204723.af7203af.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Tue, 27 Mar 2007 07:23:56 +0200
Message-Id: <1174973036.16403.41.camel@Homer.simpson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-03-26 at 20:47 -0800, Andrew Morton wrote:

> Nobody puts the description of the fields _below_ those fields.

There are also some instances of if (foo = bar()).  Maybe someone who
isn't buried in work (as you always are) can find time to review.

	-Mike

