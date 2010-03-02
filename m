Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751824Ab0CBLcL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 06:32:11 -0500
Received: from casper.infradead.org ([85.118.1.10]:44713 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750833Ab0CBLcI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 06:32:08 -0500
Subject: Re: [rfc/rft][patch] should use scheduler sync hint in
 tcp_prequeue()?
From: Peter Zijlstra <peterz@infradead.org>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>, netdev <netdev@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <1267529273.2964.111.camel@edumazet-laptop>
References: <1267522901.25906.101.camel@marge.simson.net>
	 <1267529273.2964.111.camel@edumazet-laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 02 Mar 2010 12:32:05 +0100
Message-ID: <1267529525.25158.40.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-03-02 at 12:27 +0100, Eric Dumazet wrote:
> My Q6600 has shared caches 

Isn't core2quad a dual die construct, having 2 cache domains?

