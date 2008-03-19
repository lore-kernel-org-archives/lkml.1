Return-Path: <linux-kernel-owner+w=401wt.eu-S1761365AbYCSV7e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761365AbYCSV7e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 17:59:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932746AbYCSUXK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 16:23:10 -0400
Received: from mga05.intel.com ([192.55.52.89]:1525 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932737AbYCSUXJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 16:23:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,521,1199692800"; 
   d="scan'208";a="536102596"
Subject: Re: volanoMark 12% regression with 2.6.25-rc6
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20080318195807.GA26887@elte.hu>
References: <1205831650.3215.569.camel@ymzhang>
	 <20080318195807.GA26887@elte.hu>
Content-Type: text/plain; charset=utf-8
Date: Wed, 19 Mar 2008 10:07:00 +0800
Message-Id: <1205892420.3215.594.camel@ymzhang>
Mime-Version: 1.0
X-Mailer: Evolution 2.9.2 (2.9.2-2.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-03-18 at 20:58 +0100, Ingo Molnar wrote:
> * Zhang, Yanmin <yanmin_zhang@linux.intel.com> wrote:
> 
> > Comparing with 2.6.25-rc5, volanoMark has 12% regression with 
> > 2.6.25-rc6 on my 8-core stoakley.
> 
> could you try sched/latest please? You can pick it up via:
> 
>   http://people.redhat.com/mingo/sched-devel.git/README
IT disables the git connections. I could use rsync, but it's slow to download from
China.

Could you send me a patch against 2.6.25-rc6? Or just send me the kernel/sched*.c?

yanmin


