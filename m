Return-Path: <linux-kernel-owner+w=401wt.eu-S1754693AbZCFHMR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754693AbZCFHMR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 02:12:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751362AbZCFHMA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 02:12:00 -0500
Received: from mail.gmx.net ([213.165.64.20]:38690 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751226AbZCFHMA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 02:12:00 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18qBw5By/gqj0yRG7M/ZkhrjtSWwMSjgWD2DXs3TR
	jeVb1KxbZ6QuXH
Subject: Re: [PATCH] perfcounters: IRQ and NMI support on AMD CPUs
From: Mike Galbraith <efault@gmx.de>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Paul Mackerras <paulus@samba.org>, lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <1236322300.6263.1.camel@marge.simson.net>
References: <1236273633.5187.286.camel@laptop>
	 <1236277959.3316.3.camel@localhost.localdomain>
	 <1236278730.5187.378.camel@laptop>
	 <1236279393.3316.13.camel@localhost.localdomain>
	 <1236281661.5187.432.camel@laptop>  <20090305194127.GA2039@elte.hu>
	 <1236283315.6457.4.camel@localhost.localdomain>
	 <1236321473.6030.8.camel@marge.simson.net>
	 <1236322300.6263.1.camel@marge.simson.net>
Content-Type: text/plain
Date: Fri, 06 Mar 2009 08:11:55 +0100
Message-Id: <1236323515.6497.0.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.75
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-03-06 at 07:51 +0100, Mike Galbraith wrote:

> Ah, my woes are gonna be 2743a5b0fa6f309da904f2190a9cc25deee34dbd.

(and indeed, they both work fine now)

