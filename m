Return-Path: <linux-kernel-owner+w=401wt.eu-S1761702AbXKHRyM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761702AbXKHRyM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2007 12:54:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759781AbXKHRx6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Nov 2007 12:53:58 -0500
Received: from www.tglx.de ([62.245.132.106]:56656 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758744AbXKHRx6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2007 12:53:58 -0500
Date: Thu, 8 Nov 2007 18:53:46 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Robert Richter <robert.richter@amd.com>
cc: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [patch 0/6] x86: apicdef.h unification
In-Reply-To: <20071108102411.GG20836@erda.amd.com>
Message-ID: <alpine.LRH.0.999.0711081852170.1314@www.tglx.de>
References: <20071106183645.951275000@amd.com>
 <alpine.LFD.0.9999.0711062130200.3628@localhost.localdomain>
 <20071108102411.GG20836@erda.amd.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 8 Nov 2007, Robert Richter wrote:

> Thomas,
> 
> On 06.11.07 21:32:12, Thomas Gleixner wrote:
> > Thanks for doing this, but please check the x86 git repository
> > (cleanup / mm branch) for stuff which has been worked on already.
> > 
> > Maybe we need some coordination for this.
> 
> Is it for sure that the x86/cleanup tree will go upstream soon and the
> source will not change as much? The question is what code base to use
> for new patches? I want to keep the porting effort as small as
> possible.

We'll add patches on top of the cleanup branch. There should be not much 
changes, except if we have real functional changes.

	tglx
