Return-Path: <linux-kernel-owner+w=401wt.eu-S1753092AbZCDDnv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753092AbZCDDnv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 22:43:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751618AbZCDDni
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 22:43:38 -0500
Received: from mail.gmx.net ([213.165.64.20]:53007 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750719AbZCDDnh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 22:43:37 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+iVKY3XtSiiJ74+6MJadddO68fSuDp+pQgjuZfcD
	7lmoWSPnFVpeBS
Subject: Re: x86-tip: cpufreq breakage - bisection
	fingers	89c9215165ca609096e845926d9a18f1306176a4
From: Mike Galbraith <efault@gmx.de>
To: Tejun Heo <tj@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <49ADE077.1060606@kernel.org>
References: <1236085632.5958.8.camel@marge.simson.net>
	 <20090303143106.GA12248@elte.hu> <1236098338.5926.0.camel@marge.simson.net>
	 <49ADE077.1060606@kernel.org>
Content-Type: text/plain; charset=utf-8
Date: Wed, 04 Mar 2009 04:43:25 +0100
Message-Id: <1236138205.6119.12.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 8bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.71
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-03-04 at 10:59 +0900, Tejun Heo wrote:

> I can't reproduce the problem here.

Guess I'll have to sharpen a stick or two then.

> I'll set up a 11.0 system and see whether I can reproduce the problem.
> Just in case, can you please try to rebuild after mrproper?

Yup, still there.  I even dropped the branch and started from scratch.﻿

	-Mike

