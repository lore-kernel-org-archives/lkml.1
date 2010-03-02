Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752653Ab0CBLlN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 06:41:13 -0500
Received: from mail.gmx.net ([213.165.64.20]:44653 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751576Ab0CBLlL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 06:41:11 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19L18E7+NxL1x5I/KkJSSu6/YvH61PnBR0MsEAIgq
	0dvS6cAADgx3AM
Subject: Re: [rfc/rft][patch] should use scheduler sync hint in
 tcp_prequeue()?
From: Mike Galbraith <efault@gmx.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Eric Dumazet <eric.dumazet@gmail.com>, netdev <netdev@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <1267529525.25158.40.camel@laptop>
References: <1267522901.25906.101.camel@marge.simson.net>
	 <1267529273.2964.111.camel@edumazet-laptop>
	 <1267529525.25158.40.camel@laptop>
Content-Type: text/plain
Date: Tue, 02 Mar 2010 12:41:08 +0100
Message-Id: <1267530068.9365.8.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.67000000000000004
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-03-02 at 12:32 +0100, Peter Zijlstra wrote:
> On Tue, 2010-03-02 at 12:27 +0100, Eric Dumazet wrote:
> > My Q6600 has shared caches 
> 
> Isn't core2quad a dual die construct, having 2 cache domains?

(yes.. am I using wrong terminology?)

