Return-Path: <linux-kernel-owner+w=401wt.eu-S1754938AbYADUEZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754938AbYADUEZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2008 15:04:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754765AbYADUEN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jan 2008 15:04:13 -0500
Received: from mail.gmx.net ([213.165.64.20]:42460 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754738AbYADUEM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2008 15:04:12 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/7zphDLLH7jgWmVBtaa0KHpVvFQUGdrYTNMsFw1M
	j4+ns8nrVjRXKj
Subject: Re: [patch?] s2ram + P4 + tsc = annoyance
From: Mike Galbraith <efault@gmx.de>
To: Pavel Machek <pavel@ucw.cz>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20080104163914.GA27447@elf.ucw.cz>
References: <1198745736.4235.23.camel@homer.simson.net>
	 <1198779574.4425.50.camel@homer.simson.net>
	 <20071230140456.GJ16946@elte.hu> <20071230140815.GA27858@elte.hu>
	 <20080104163914.GA27447@elf.ucw.cz>
Content-Type: text/plain
Date: Fri, 04 Jan 2008 23:04:03 +0100
Message-Id: <1199484243.4240.38.camel@homer.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2008-01-04 at 17:39 +0100, Pavel Machek wrote:

> If it is too dangerous for -final, I guess it is bad idea to push it
> into -stable.
> 
> Plus it does not fix really bad bug.

The furthest back burner is fine.  It's only an annoyance.
 
	-Mike

