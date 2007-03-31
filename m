Return-Path: <linux-kernel-owner+w=401wt.eu-S965254AbXCaGts@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965254AbXCaGts (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2007 02:49:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965275AbXCaGts
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Mar 2007 02:49:48 -0400
Received: from mail.gmx.net ([213.165.64.20]:49199 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S965254AbXCaGts (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2007 02:49:48 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+kqWZhcbWksc/z+uH1tAUF1qE2+2O2cJccn3ynQs
	EaLZTQaKsrLVq0
Subject: Re: [test] hackbench.c interactivity results: vanilla versus
	SD/RSDL
From: Mike Galbraith <efault@gmx.de>
To: Xenofon Antidides <xantidides@yahoo.gr>
Cc: Ingo Molnar <mingo@elte.hu>, Con Kolivas <kernel@kolivas.org>,
       linux list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <1175322706.6030.20.camel@Homer.simpson.net>
References: <834572.46808.qm@web26713.mail.ukl.yahoo.com>
	 <1175322706.6030.20.camel@Homer.simpson.net>
Content-Type: text/plain
Date: Sat, 31 Mar 2007 08:49:46 +0200
Message-Id: <1175323786.6030.28.camel@Homer.simpson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-03-31 at 08:31 +0200, Mike Galbraith wrote:
> On Fri, 2007-03-30 at 22:41 -0700, Xenofon Antidides wrote:
> 
> > Patch makes X yuck with any load. I stick with SD.

General comment directed at nobody in particular:

If anyone thinks the current scheduler sucks rocks, maybe they should
try to fix it.  If they think SD is the best thing since sliced bread,
maybe they should help Con fix that.  Code talks...

	-Mike

