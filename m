Return-Path: <linux-kernel-owner+w=401wt.eu-S1753640AbYDBIDT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753640AbYDBIDT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 04:03:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752109AbYDBIC4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 04:02:56 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:59849 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751753AbYDBICy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 04:02:54 -0400
Date: Wed, 2 Apr 2008 13:42:57 +0530
From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>, aneesh.kumar@linux.vnet.ibm.com,
       dhaval@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
       Balbir Singh <balbir@in.ibm.com>
Subject: Re: set_task_rq bug?
Message-ID: <20080402081257.GF17617@linux.vnet.ibm.com>
Reply-To: vatsa@linux.vnet.ibm.com
References: <20080402075255.GE17617@linux.vnet.ibm.com> <1207122537.8514.752.camel@twins>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1207122537.8514.752.camel@twins>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 02, 2008 at 09:48:57AM +0200, Peter Zijlstra wrote:
> with !CONFIG_FAIR_GROUP_SCHED se.cfs_rq isn't even there.

You are right ..sorry abt the noise!

-- 
Regards,
vatsa
