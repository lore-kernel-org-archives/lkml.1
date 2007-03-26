Return-Path: <linux-kernel-owner+w=401wt.eu-S1751980AbXCZIjJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751980AbXCZIjJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 04:39:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752691AbXCZIjI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 04:39:08 -0400
Received: from mail.gmx.net ([213.165.64.20]:48298 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751980AbXCZIjG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 04:39:06 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19BDbkip7xBcagCTBd3DZBErR3bW6rDWhSZJlC2Mo
	yFa0wZwydohFhD
Subject: Re: rSDl cpu scheduler version 0.34-test patch
From: Mike Galbraith <efault@gmx.de>
To: Con Kolivas <kernel@kolivas.org>
Cc: linux list <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       ck list <ck@vds.kolivas.org>, Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <1174896613.6664.30.camel@Homer.simpson.net>
References: <200703261100.22467.kernel@kolivas.org>
	 <1174885253.7040.57.camel@Homer.simpson.net>
	 <200703261719.01444.kernel@kolivas.org>
	 <1174896613.6664.30.camel@Homer.simpson.net>
Content-Type: text/plain
Date: Mon, 26 Mar 2007 10:39:02 +0200
Message-Id: <1174898342.7051.4.camel@Homer.simpson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

P.S.  (I've not studied the hotplug code)  When a cpu is hot-unplugged,
are it's runqueues and whatnot deallocated?  (i should just go look, but
by the time i get around to it, some nice person may have already put an
answer in my mailbox;)

	-Mike

P.S.#2:  not only bitmap are zeroed, task is issued a fresh time_slice.

	-Mike

