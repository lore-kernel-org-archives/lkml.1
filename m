Return-Path: <linux-kernel-owner+w=401wt.eu-S1752093Ab0AKGwo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752093Ab0AKGwo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 01:52:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751684Ab0AKGwn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 01:52:43 -0500
Received: from mail.gmx.net ([213.165.64.20]:55612 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751490Ab0AKGwm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 01:52:42 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18aOCpLrFgaTBYUDa+w8dQ9MW8TFZgoNhrvTcHHZr
	er+xLTG+OCZIfo
Subject: Re: [Bug #15034] volano ~30% regression
From: Mike Galbraith <efault@gmx.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Lin Ming <ming.m.lin@intel.com>
In-Reply-To: <omZ8aBZReyD.A.BXG.2MlSLB@chimera>
References: <wnS54-l8PVO.A.TlF.oMlSLB@chimera>
	 <omZ8aBZReyD.A.BXG.2MlSLB@chimera>
Content-Type: text/plain
Date: Mon, 11 Jan 2010 07:52:38 +0100
Message-Id: <1263192758.6444.9.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.54
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-01-10 at 23:32 +0100, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.32.  Please verify if it still should be listed and let me know
> (either way).

A verified fix for this one is in the pipe.

> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15034
> Subject		: volano ~30% regression
> Submitter	: Lin Ming <ming.m.lin@intel.com>
> Date		: 2010-01-04 8:15 (7 days old)
> References	: http://marc.info/?l=linux-kernel&m=126259391411982&w=4
> Handled-By	: Mike Galbraith <efault@gmx.de>
> Patch		: http://patchwork.kernel.org/patch/70623/


