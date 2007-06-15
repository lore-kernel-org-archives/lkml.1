Return-Path: <linux-kernel-owner+w=401wt.eu-S1756184AbXFOMt0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756184AbXFOMt0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 08:49:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754268AbXFOMtT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 08:49:19 -0400
Received: from mailhub.sw.ru ([195.214.233.200]:19567 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753607AbXFOMtS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 08:49:18 -0400
Message-ID: <46728A15.5050905@sw.ru>
Date: Fri, 15 Jun 2007 16:46:13 +0400
From: Kirill Korotaev <dev@sw.ru>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.13) Gecko/20060417
X-Accept-Language: en-us, en, ru
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>, efault@gmx.de,
       kernel@kolivas.org, containers@lists.osdl.org,
       ckrm-tech@lists.sourceforge.net, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, pwil3058@bigpond.net.au, tingy@cs.umass.edu,
       tong.n.li@intel.com, wli@holomorphy.com, linux-kernel@vger.kernel.org,
       dmitry.adamushko@gmail.com, balbir@in.ibm.com
Subject: Re: [RFC][PATCH 0/6] Add group fairness to CFS - v1
References: <20070611154724.GA32435@in.ibm.com> <20070611193735.GA22152@elte.hu> <20070612055024.GA26957@in.ibm.com> <20070612062612.GA19637@elte.hu>
In-Reply-To: <20070612062612.GA19637@elte.hu>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:

> i'd still like to hear back from Kirill & co whether this framework is 
> flexible enough for their work (OpenVZ, etc.) too.

My IMHO is that so far the proposed group scheduler doesn't look ready/suitable.
We need to have a working SMP version before it will be clear
whether the whole approach is good and works correct on variety of load patterns.

Thanks,
Kirill

