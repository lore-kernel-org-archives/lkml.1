Return-Path: <linux-kernel-owner+w=401wt.eu-S1752737AbZLQFnG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752737AbZLQFnG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 00:43:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752529AbZLQFnA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 00:43:00 -0500
Received: from ozlabs.org ([203.10.76.45]:37798 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752505AbZLQFnA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 00:43:00 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Tejun Heo <tj@kernel.org>
Subject: Re: [this_cpu_xx V7 7/8] Module handling: Use this_cpu_xx to dynamically allocate counters
Date: Thu, 17 Dec 2009 16:12:53 +1030
User-Agent: KMail/1.12.2 (Linux/2.6.31-16-generic; KDE/4.3.2; i686; ; )
Cc: Christoph Lameter <cl@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Mel Gorman <mel@csn.ul.ie>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
References: <20091214220320.665065925@quilx.com> <alpine.DEB.2.00.0912160900470.8572@router.home> <4B297A69.2010504@kernel.org>
In-Reply-To: <4B297A69.2010504@kernel.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200912171612.54117.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Dec 2009 10:55:13 am Tejun Heo wrote:
> Hello,
> 
> On 12/17/2009 01:10 AM, Christoph Lameter wrote:
> > Fixup patch:
> > 
> > Subject: Extend preempt_disable section around module_is_live()
> > 
> > Signed-off-by: Christoph Lameter <cl@linux-foundation.org>
> 
> Looks good to me but as the patch currently isn't any tree, it'll
> probably be better to merge it into the original patch.  Rusty, do you
> want to take this one?  If not, I can route it through percpu tree.

Easiest to go with your stuff I think:

	Acked-by: Rusty Russell <rusty@rustcorp.com.au>

Thanks,
Rusty.
