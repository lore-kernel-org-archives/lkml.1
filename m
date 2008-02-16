Return-Path: <linux-kernel-owner+w=401wt.eu-S1753265AbYBPKmI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753265AbYBPKmI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2008 05:42:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750883AbYBPKl4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Feb 2008 05:41:56 -0500
Received: from smtp3-g19.free.fr ([212.27.42.29]:43040 "EHLO smtp3-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750862AbYBPKl4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2008 05:41:56 -0500
Message-ID: <47B6BDDF.90502@inria.fr>
Date: Sat, 16 Feb 2008 11:41:35 +0100
From: Brice Goglin <Brice.Goglin@inria.fr>
User-Agent: Mozilla-Thunderbird 2.0.0.9 (X11/20080110)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Christoph Lameter <clameter@sgi.com>,
       Andrea Arcangeli <andrea@qumranet.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [patch 1/6] mmu_notifier: Core code
References: <20080215064859.384203497@sgi.com>	<20080215064932.371510599@sgi.com> <20080215193719.262c03a1.akpm@linux-foundation.org>
In-Reply-To: <20080215193719.262c03a1.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> What is the status of getting infiniband to use this facility?
>
> How important is this feature to KVM?
>
> To xpmem?
>
> Which other potential clients have been identified and how important it it
> to those?
>   

As I said when Andrea posted the first patch series, I used something
very similar for non-RDMA-based HPC about 4 years ago. I haven't had
time yet to look in depth and try the latest proposed API but my feeling
is that it looks good.

Brice

