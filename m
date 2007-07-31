Return-Path: <linux-kernel-owner+w=401wt.eu-S1758004AbXGaLCh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758004AbXGaLCh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 07:02:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755150AbXGaLC3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 07:02:29 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:54295 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754320AbXGaLC2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 07:02:28 -0400
Message-ID: <46AF16CA.4020103@bull.net>
Date: Tue, 31 Jul 2007 13:02:34 +0200
From: Zoltan Menyhart <Zoltan.Menyhart@bull.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.3) Gecko/20040913
X-Accept-Language: en-us, en, fr, hu
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: David Mosberger-Tang <dmosberger@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>,
       "tony.luck@intel.com" <tony.luck@intel.com>,
       Christoph Lameter <clameter@sgi.com>
Subject: Re: [PATCH] flush icache before set_pte take6. [4/4] optimization
 for cpus other than montecito
References: <20070731113543.93ffd964.kamezawa.hiroyu@jp.fujitsu.com>	<20070731114155.5785123c.kamezawa.hiroyu@jp.fujitsu.com>	<ed5aea430707302115h484620f1le51fc054436b273a@mail.gmail.com>	<46AEF518.4000002@bull.net> <20070731191749.0709c56e.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20070731191749.0709c56e.kamezawa.hiroyu@jp.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 31/07/2007 13:07:14,
	Serialize by Router on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 31/07/2007 13:07:16,
	Serialize complete at 31/07/2007 13:07:16
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=us-ascii; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

KAMEZAWA Hiroyuki wrote:

> Could we discuss this in other thread as "optimization for some cpus" and
> push bug-fix patches first ?
> 
> If take5 or part of take6(patch 1,2) are not acceptable, I'll continue this
> work on -rc2.
> 
> Thanks,
> -Kame

Sure.

Thanks,

Zoltan
