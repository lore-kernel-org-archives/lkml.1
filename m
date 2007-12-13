Return-Path: <linux-kernel-owner+w=401wt.eu-S1759804AbXLMM25@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759804AbXLMM25 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 07:28:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752538AbXLMM2r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 07:28:47 -0500
Received: from e28smtp07.in.ibm.com ([59.145.155.7]:49912 "EHLO
	e28esmtp07.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751137AbXLMM2r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 07:28:47 -0500
Date: Thu, 13 Dec 2007 17:58:02 +0530
From: Gautham R Shenoy <ego@in.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       jirislaby@gmail.com
Subject: Re: 2.6.24-rc5-mm1
Message-ID: <20071213122802.GA30427@in.ibm.com>
Reply-To: ego@in.ibm.com
References: <20071213024050.7d6e5f3e.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071213024050.7d6e5f3e.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew, 
On Thu, Dec 13, 2007 at 02:40:50AM -0800, Andrew Morton wrote:
> 
> 
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.24-rc5/2.6.24-rc5-mm1/
> 
> - If something goes wrong with a PCI device's probing or initialisation, try
>   reverting pci-disable-decoding-during-sizing-of-bars.patch.
> 
> - git-sched was dropped due to breaking suspend-to-RAM.

Is it the same suspend-to-RAM problem that Jiri Slaby reported 
here --> http://lkml.org/lkml/2007/12/7/125

The problem has been identified and a fix patch was provided.


Thanks and Regards
gautham.
-- 
Gautham R Shenoy
Linux Technology Center
IBM India.
"Freedom comes with a price tag of responsibility, which is still a bargain,
because Freedom is priceless!"
