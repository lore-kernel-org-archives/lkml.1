Return-Path: <linux-kernel-owner+w=401wt.eu-S1763011AbZLQAYA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763011AbZLQAYA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 19:24:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762845AbZLQAX6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 19:23:58 -0500
Received: from hera.kernel.org ([140.211.167.34]:49732 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762857AbZLQAX4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 19:23:56 -0500
Message-ID: <4B297A69.2010504@kernel.org>
Date: Thu, 17 Dec 2009 09:25:13 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Christoph Lameter <cl@linux-foundation.org>
CC: Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
       Mel Gorman <mel@csn.ul.ie>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: Re: [this_cpu_xx V7 7/8] Module handling: Use this_cpu_xx to dynamically
 allocate counters
References: <20091214220320.665065925@quilx.com> <20091214220342.473600725@quilx.com> <4B270AA6.3050307@kernel.org> <200912160911.43201.rusty@rustcorp.com.au> <alpine.DEB.2.00.0912160900470.8572@router.home>
In-Reply-To: <alpine.DEB.2.00.0912160900470.8572@router.home>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 12/17/2009 01:10 AM, Christoph Lameter wrote:
> Fixup patch:
> 
> Subject: Extend preempt_disable section around module_is_live()
> 
> Signed-off-by: Christoph Lameter <cl@linux-foundation.org>

Looks good to me but as the patch currently isn't any tree, it'll
probably be better to merge it into the original patch.  Rusty, do you
want to take this one?  If not, I can route it through percpu tree.

Thanks.

-- 
tejun
