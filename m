Return-Path: <linux-kernel-owner+w=401wt.eu-S1757476AbYFIR1l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757476AbYFIR1l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 13:27:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753704AbYFIR1d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 13:27:33 -0400
Received: from e28smtp05.in.ibm.com ([59.145.155.5]:40744 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753634AbYFIR1d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 13:27:33 -0400
Message-ID: <484D67EF.5090203@linux.vnet.ibm.com>
Date: Mon, 09 Jun 2008 22:57:11 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: 2.6.26-rc5-mm1
References: <20080609053908.8021a635.akpm@linux-foundation.org>
In-Reply-To: <20080609053908.8021a635.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> Temporarily at
> 
>   http://userweb.kernel.org/~akpm/2.6.26-rc5-mm1/
> 

I've hit a segfault, the last few lines on my console are


Testing -fstack-protector-all feature
registered taskstats version 1
debug: unmapping init memory ffffffff80c03000..ffffffff80dd8000
init[1]: segfault at 7fff701fe880 ip 7fff701fee5e sp 7fff7006e6d0 error 7

With absolutely no stack trace. I'll dig deeper.

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
