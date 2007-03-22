Return-Path: <linux-kernel-owner+w=401wt.eu-S965648AbXCVEQK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965648AbXCVEQK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 00:16:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965656AbXCVEQK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 00:16:10 -0400
Received: from 1wt.eu ([62.212.114.60]:1317 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965648AbXCVEQJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 00:16:09 -0400
Date: Thu, 22 Mar 2007 05:12:42 +0100
From: Willy Tarreau <w@1wt.eu>
To: Dave Jones <davej@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Andi Kleen <andi@firstfloor.org>,
       "Robert P. J. Day" <rpjday@mindspring.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@stusta.de>
Subject: Re: [PATCH] Delete obsolete RAW driver feature.
Message-ID: <20070322041242.GA29741@1wt.eu>
References: <Pine.LNX.4.64.0703180754060.6605@CPE00045a9c397f-CM001225dbafb6> <p73y7lu5yt6.fsf@bingen.suse.de> <20070320165736.GA19781@redhat.com> <20070320181442.1ae73295@lxorguk.ukuu.org.uk> <20070321151952.02b5612d.akpm@linux-foundation.org> <20070322001050.13588e5e@lxorguk.ukuu.org.uk> <20070321161341.0f87ed60.akpm@linux-foundation.org> <20070321232433.GX943@1wt.eu> <20070321234318.GE9092@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070321234318.GE9092@redhat.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 21, 2007 at 07:43:18PM -0400, Dave Jones wrote:
> On Thu, Mar 22, 2007 at 12:24:33AM +0100, Willy Tarreau wrote:
>  
>  > Then a printk() on every open() should be enough. We've all been seeing
>  > "Warning: tcpdump uses obsolete AF_PACKET"... and it finally disappeared.
> 
> There's a difference.  We have the source for tcpdump.

But what's the problem with "warning: process XXX uses obsolete raw driver
and may not work anymore after 2007/XX/XX if not fixed" ?

Willy

