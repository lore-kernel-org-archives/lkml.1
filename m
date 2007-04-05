Return-Path: <linux-kernel-owner+w=401wt.eu-S1767161AbXDERrj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767161AbXDERrj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 13:47:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767035AbXDERri
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 13:47:38 -0400
Received: from amsfep20-int.chello.nl ([62.179.120.15]:46773 "EHLO
	amsfep20-int.chello.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767161AbXDERrh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 13:47:37 -0400
Subject: Re: [PATCH 00/12] per device dirty throttling -v3
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-mm@kvack.org, linux-kernel <linux-kernel@vger.kernel.org>
Cc: miklos@szeredi.hu, akpm@linux-foundation.org, neilb@suse.de, dgc@sgi.com,
       tomoki.sekiyama.qu@hitachi.com, nikita@clusterfs.com
In-Reply-To: <20070405174209.498059336@programming.kicks-ass.net>
References: <20070405174209.498059336@programming.kicks-ass.net>
Content-Type: text/plain
Date: Thu, 05 Apr 2007 19:47:33 +0200
Message-Id: <1175795253.6483.110.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Don't worry, it's me!

Seems I forgot to edit the From field :-(

On Thu, 2007-04-05 at 19:42 +0200, root@programming.kicks-ass.net wrote:
> Against 2.6.21-rc5-mm4 without:
>   per-backing_dev-dirty-and-writeback-page-accounting.patch
> 
> This series implements BDI independent dirty limits and congestion control.
> 
> This should solve several problems we currently have in this area:
> 
>  - mutual interference starvation (for any number of BDIs), and
>  - deadlocks with stacked BDIs (loop and FUSE).
> 
> All the fancy new congestion code has been compile and boot tested, but
> not much more. I'm posting to get feedback on the ideas.
> 
> 

