Return-Path: <linux-kernel-owner+w=401wt.eu-S966148AbXDCCKu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966148AbXDCCKu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 22:10:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966150AbXDCCKu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 22:10:50 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:55261 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966148AbXDCCKu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 22:10:50 -0400
Date: Mon, 2 Apr 2007 19:09:21 -0700
From: Nishanth Aravamudan <nacc@us.ibm.com>
To: agl@us.ibm.com, dwg@au1.ibm.com
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: hugetlb: Unable to handle kernel NULL pointer dereference
Message-ID: <20070403020921.GA7444@us.ibm.com>
References: <20070403014608.GA29601@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070403014608.GA29601@us.ibm.com>
X-Operating-System: Linux 2.6.21-rc5-g59117d3f (x86_64)
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 02.04.2007 [18:46:08 -0700], Nishanth Aravamudan wrote:
> Adam, David,
> 
> Just got the following Oops and recursive fault running `make func`
> (apparently the `shared` test in particular) with kernel HEAD at
> efab03d998da03f67836ffc664b04e0400f85448 on my x86_64. Will pull latest
> Linus and reboot, but haven't seen it posted yet. This occurs both with
> my branch and master from libhugetlbfs.

Bah, blame operator error, perhaps. Not able to reproduce with current
Linus tip.

Thanks,
Nish

-- 
Nishanth Aravamudan <nacc@us.ibm.com>
IBM Linux Technology Center
