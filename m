Return-Path: <linux-kernel-owner+w=401wt.eu-S1752812AbXDCFYH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752812AbXDCFYH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 01:24:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752826AbXDCFYH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 01:24:07 -0400
Received: from mail.gmx.net ([213.165.64.20]:42599 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752812AbXDCFYG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 01:24:06 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/yVJ0hYzjyIHsX1oVWQkN5NfB+cMwnCggvJ9JGAk
	0TcpExHQ8B7Hu8
Subject: Re: [test] hackbench.c interactivity results: vanilla versus
	SD/RSDL
From: Mike Galbraith <efault@gmx.de>
To: Con Kolivas <kernel@kolivas.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <200704031234.48863.kernel@kolivas.org>
References: <20070331092857.12651.qmail@web26704.mail.ukl.yahoo.com>
	 <200704031234.48863.kernel@kolivas.org>
Content-Type: text/plain
Date: Tue, 03 Apr 2007 07:24:01 +0200
Message-Id: <1175577841.6342.4.camel@Homer.simpson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-04-03 at 12:34 +1000, Con Kolivas wrote:
> On Saturday 31 March 2007 19:28, Xenofon Antidides wrote:
> > For long time now I use windows to work 
> > problems. I cannot play wine games with audio, I
> > cannot sample video, I cannot use skype, I cannot play
> > midi. And even linux only things I try do I cannot
> > share my X, I cannot use more than one vmware. All
> > those is fix for me with SD.
> 
> Any semblance of cpu bandwidth and latency guarantees are easily shot on 
> mainline by a single process going wild (eg open tab in firefox).

I've written a patch which I believe fixes that.

	-Mike

