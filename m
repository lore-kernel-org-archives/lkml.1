Return-Path: <linux-kernel-owner+w=401wt.eu-S1762889AbXIMJzF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762889AbXIMJzF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 05:55:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751055AbXIMJyy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 05:54:54 -0400
Received: from mx1.suse.de ([195.135.220.2]:50447 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751004AbXIMJyx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 05:54:53 -0400
From: Andi Kleen <ak@suse.de>
To: travis@sgi.com
Subject: Re: [PATCH 00/10] x86: Reduce Memory Usage and Inter-Node message traffic (v3)
Date: Thu, 13 Sep 2007 11:53:32 +0200
User-Agent: KMail/1.9.1
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <clameter@sgi.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       sparclinux@vger.kernel.org
References: <20070912015644.927677070@sgi.com>
In-Reply-To: <20070912015644.927677070@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709131153.32576.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 12 September 2007 03:56, travis@sgi.com wrote:
> Note:
>
> This patch consolidates all the previous patches regarding
> the conversion of static arrays sized by NR_CPUS into per_cpu
> data arrays and is referenced against 2.6.23-rc6 .


Looks good to me from the x86 side. I'll leave it to Andrew to
handle for now though because it touches too many files
outside x86.

-Andi
