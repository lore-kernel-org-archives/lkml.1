Return-Path: <linux-kernel-owner+w=401wt.eu-S1753927Ab0AEGct@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753927Ab0AEGct (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 01:32:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752755Ab0AEGct
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 01:32:49 -0500
Received: from hera.kernel.org ([140.211.167.34]:37077 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752441Ab0AEGcs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 01:32:48 -0500
Message-ID: <4B42DE39.20309@kernel.org>
Date: Tue, 05 Jan 2010 15:37:45 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Christoph Lameter <cl@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, Mel Gorman <mel@csn.ul.ie>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: Re: [this_cpu_xx V9 0/7] Per cpu atomics in page allocator, modules,
 cleanup and optimized inc/dec
References: <20100104223439.228028923@quilx.com>
In-Reply-To: <20100104223439.228028923@quilx.com>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

1-7 applied to the following git branch.

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/percpu.git percpu

and also pushed out to linux-next.  Please base further changes on top
of the #percpu branch.

Thanks.

-- 
tejun
