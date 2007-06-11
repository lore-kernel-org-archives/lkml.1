Return-Path: <linux-kernel-owner+w=401wt.eu-S1755952AbXFKPyW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755952AbXFKPyW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 11:54:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753794AbXFKPyH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 11:54:07 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:44577 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753429AbXFKPyE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 11:54:04 -0400
Date: Mon, 11 Jun 2007 21:32:28 +0530
From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>, efault@gmx.de, kernel@kolivas.org,
       containers@lists.osdl.org, ckrm-tech@lists.sourceforge.net,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       pwil3058@bigpond.net.au, tingy@cs.umass.edu, tong.n.li@intel.com,
       wli@holomorphy.com, linux-kernel@vger.kernel.org,
       dmitry.adamushko@gmail.com, balbir@in.ibm.com
Subject: Re: [RFC][PATCH 0/6] Add group fairness to CFS - v1
Message-ID: <20070611160228.GG2109@in.ibm.com>
Reply-To: vatsa@linux.vnet.ibm.com
References: <20070611154724.GA32435@in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070611154724.GA32435@in.ibm.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 11, 2007 at 09:17:24PM +0530, Srivatsa Vaddagiri wrote:
> TODO:
>
> 	- Weighted fair-share support
> 		Currently each group gets "equal" share. Support
> 		weighted fair-share so that some groups deemed important
> 		get more than this "equal" share. I believe it is
> 		possible to use load_weight to achieve this goal
> 		(similar to how niced tasks use it to get differential 
> 		bandwidth)

[snip]

	+ Fix CFS debug interface to be group aware

-- 
Regards,
vatsa
