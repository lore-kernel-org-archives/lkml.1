Return-Path: <linux-kernel-owner+w=401wt.eu-S1760682AbXGJQcN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760682AbXGJQcN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 12:32:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755160AbXGJQb7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 12:31:59 -0400
Received: from mga09.intel.com ([134.134.136.24]:26309 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755094AbXGJQb6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 12:31:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,523,1175497200"; 
   d="scan'208";a="104808317"
Message-ID: <4693B47B.7050406@intel.com>
Date: Tue, 10 Jul 2007 09:31:55 -0700
From: "Kok, Auke" <auke-jan.h.kok@intel.com>
User-Agent: Thunderbird 2.0.0.4 (X11/20070623)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, "Nelson, Shannon" <shannon.nelson@intel.com>,
       "Leech, Christopher" <christopher.leech@intel.com>
Subject: Re: -mm merge plans for 2.6.23 - ioat/dma engine
References: <20070710013152.ef2cd200.akpm@linux-foundation.org>
In-Reply-To: <20070710013152.ef2cd200.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 10 Jul 2007 16:31:57.0254 (UTC) FILETIME=[D538BE60:01C7C30F]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> git-ioat-vs-git-md-accel.patch
> ioat-warning-fix.patch
> fix-i-oat-for-kexec.patch
> 
>  I don't seem to be able to get rid of these.  Chris Leech appears to have
>  vanished.

Chris is a moving target. Thankfully we have Shannon Nelson taking over Chris' 
duties. Shannon, can you take a look at these and see what needs to happen to it 
? Most likely these just need to be pushed to the right person.

Cheers,

Auke


PS: I think we should add an I/OAT / DMA engine section in the MAINTAINERS...
