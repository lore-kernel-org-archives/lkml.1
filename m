Return-Path: <linux-kernel-owner+w=401wt.eu-S1756133AbYE3GoV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756133AbYE3GoV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 02:44:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751761AbYE3GoM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 02:44:12 -0400
Received: from E23SMTP04.au.ibm.com ([202.81.18.173]:47978 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751307AbYE3GoL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 02:44:11 -0400
Date: Fri, 30 May 2008 12:13:24 +0530
From: Dhaval Giani <dhaval@linux.vnet.ibm.com>
To: Chris Friesen <cfriesen@nortel.com>
Cc: vatsa@linux.vnet.ibm.com, linux-kernel@vger.kernel.org, mingo@elte.hu,
       a.p.zijlstra@chello.nl, pj@sgi.com, Balbir Singh <balbir@in.ibm.com>,
       aneesh.kumar@linux.vnet.ibm.com
Subject: Re: fair group scheduler not so fair?
Message-ID: <20080530064324.GA29381@linux.vnet.ibm.com>
Reply-To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
References: <4834B75A.40900@nortel.com> <20080527171528.GD30285@linux.vnet.ibm.com> <483C4F5A.2010104@nortel.com> <20080528163318.GG30285@linux.vnet.ibm.com> <483DA5E7.5050600@nortel.com> <20080529164607.GC12836@linux.vnet.ibm.com> <483F207D.4010908@nortel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <483F207D.4010908@nortel.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Also, although the long-term results are good, the shorter-term fairness 
> isn't great.  Is there a tuneable that would allow for a tradeoff between 
> performance and fairness?  I have people that are looking for within 4% 
> fairness over a 1sec interval.
>

How fair does smp fairness look for a !group scenario? I don't expect
group schould be able to do much better.

-- 
regards,
Dhaval
