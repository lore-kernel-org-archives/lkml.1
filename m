Return-Path: <linux-kernel-owner+w=401wt.eu-S1756733AbZAVLYP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756733AbZAVLYP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 06:24:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754515AbZAVLX5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 06:23:57 -0500
Received: from mx2.redhat.com ([66.187.237.31]:48317 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751621AbZAVLX5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 06:23:57 -0500
Date: Thu, 22 Jan 2009 12:22:38 +0100
From: Karel Zak <kzak@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Stephane Eranian <eranian@googlemail.com>,
       Eric Dumazet <dada1@cosmosbay.com>,
       Robert Richter <robert.richter@amd.com>,
       Arjan van de Ven <arjan@infradead.org>, Peter Anvin <hpa@zytor.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>,
       "David S. Miller" <davem@davemloft.net>, Mike Galbraith <efault@gmx.de>
Subject: Re: [announce] Performance Counters for Linux, v6
Message-ID: <20090122112238.GC7131@nb.net.home>
References: <20090121185021.GA8852@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090121185021.GA8852@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


 Hi,

On Wed, Jan 21, 2009 at 07:50:21PM +0100, Ingo Molnar wrote:
>  - The 'perfstat' utility (ex 'timec') has been updated:
> 
>       http://people.redhat.com/mingo/perfcounters/perfstat.c

 what are your planning to do with this utility? We can merge it into
 util-linux-ng.

    Karel

-- 
 Karel Zak  <kzak@redhat.com>
