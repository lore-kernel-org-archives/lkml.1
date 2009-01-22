Return-Path: <linux-kernel-owner+w=401wt.eu-S1757404AbZAVMGT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757404AbZAVMGT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 07:06:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754443AbZAVMGD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 07:06:03 -0500
Received: from mx2.redhat.com ([66.187.237.31]:52215 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753046AbZAVMGB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 07:06:01 -0500
Date: Thu, 22 Jan 2009 13:04:59 +0100
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
Message-ID: <20090122120459.GD7131@nb.net.home>
References: <20090121185021.GA8852@elte.hu> <20090122112238.GC7131@nb.net.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090122112238.GC7131@nb.net.home>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 22, 2009 at 12:22:38PM +0100, Karel Zak wrote:
> On Wed, Jan 21, 2009 at 07:50:21PM +0100, Ingo Molnar wrote:
> >  - The 'perfstat' utility (ex 'timec') has been updated:
> > 
> >       http://people.redhat.com/mingo/perfcounters/perfstat.c
> 
>  what are your planning to do with this utility? We can merge it into

grr..  s/your/you/

>  util-linux-ng.
> 
>     Karel

-- 
 Karel Zak  <kzak@redhat.com>
