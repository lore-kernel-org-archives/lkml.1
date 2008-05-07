Return-Path: <linux-kernel-owner+w=401wt.eu-S1764536AbYEGRnq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764536AbYEGRnq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 13:43:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757395AbYEGRne
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 13:43:34 -0400
Received: from E23SMTP03.au.ibm.com ([202.81.18.172]:58022 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753471AbYEGRnc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 13:43:32 -0400
Date: Wed, 7 May 2008 23:12:09 +0530
From: Dhaval Giani <dhaval@linux.vnet.ibm.com>
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: volanoMark regression with kernel 2.6.26-rc1
Message-ID: <20080507174209.GB4424@linux.vnet.ibm.com>
Reply-To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
References: <1210039590.3453.18.camel@ymzhang>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1210039590.3453.18.camel@ymzhang>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 06, 2008 at 10:06:30AM +0800, Zhang, Yanmin wrote:
> Comparing with 2.6.25, volanoMark has big regression with kernel 2.6.26-rc1.
> It's about 50% on my 8-core stoakley, 16-core tigerton, and Itanium Montecito.
> 

Just FYI, I am actually seeing 5 times performance on 2.6.26-rc1
(I ran the benchmark twice before i sent out this mail and both
times I have have these numbers)

-- 
regards,
Dhaval
