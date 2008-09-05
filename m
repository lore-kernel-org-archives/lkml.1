Return-Path: <linux-kernel-owner+w=401wt.eu-S1753418AbYIEUO2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753418AbYIEUO2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 16:14:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751524AbYIEUOT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 16:14:19 -0400
Received: from r00tworld.com ([212.85.137.21]:52401 "EHLO r00tworld.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751412AbYIEUOS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 16:14:18 -0400
From: pageexec@freemail.hu
To: Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>
Date: Fri, 05 Sep 2008 21:42:48 +0200
MIME-Version: 1.0
Subject: Re: [patch] Add basic sanity checks to the syscall execution patch
Reply-to: pageexec@freemail.hu
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Andi Kleen <andi@firstfloor.org>,
       Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       tglx@tglx.de, hpa@zytor.com
Message-ID: <48C18BB8.13126.4E8982B@pageexec.freemail.hu>
In-reply-to: <20080905172644.GV18288@one.firstfloor.org>
References: <20080905154221.GF10292@elte.hu>, <20080905165239.GA12645@elte.hu>, <20080905172644.GV18288@one.firstfloor.org>
X-mailer: Pegasus Mail for Windows (4.50 PB1)
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7BIT
Content-description: Mail message body
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-2.1.12 (r00tworld.com [212.85.137.21]); Fri, 05 Sep 2008 21:43:16 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5 Sep 2008 at 19:26, Andi Kleen wrote:

> 
> First such checkers already exist -- they are called root kit checkers.
> There are various around. 
> Usually operate from user space. You could run them in a cron job.

how trivial do you think it is for *kernel* code to evade *userland*
checking it? ;) otherwise agreed with rest.

