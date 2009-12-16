Return-Path: <linux-kernel-owner+w=401wt.eu-S1760069AbZLPJCS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760069AbZLPJCS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 04:02:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755533AbZLPJCR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 04:02:17 -0500
Received: from mail.mellanox.co.il ([194.90.237.43]:57645 "EHLO mellanox.co.il"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752396AbZLPJCO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 04:02:14 -0500
Message-ID: <4B28A259.3040909@mellanox.co.il>
Date: Wed, 16 Dec 2009 11:03:21 +0200
From: Tziporet Koren <tziporet@mellanox.co.il>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.1.5) Gecko/20091204 Thunderbird/3.0
MIME-Version: 1.0
To: Roland Dreier <rdreier@cisco.com>
CC: linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
       Yevgeny Petrilin <yevgenyp@mellanox.co.il>
Subject: Re: InfiniBand/RDMA merge plans for 2.6.33
References: <adaocm1csgb.fsf@roland-alpha.cisco.com>
In-Reply-To: <adaocm1csgb.fsf@roland-alpha.cisco.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 16 Dec 2009 09:01:23.0193 (UTC) FILETIME=[574FE690:01CA7E2E]
X-TM-AS-Product-Ver: SMEX-8.0.0.1181-6.000.1038-17072.006
X-TM-AS-Result: No--8.904500-8.000000-31
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/14/2009 8:37 PM, Roland Dreier wrote:
>
>   - mlx4 SR-IOV support.  Again, main problem was my lack of time.  I
>     agree in principle with this stuff, just want to be careful that we
>     don't turn the mlx4 driver into an unmaintainable mess of "if
>     (sriov) something; else something_else" all over.
>    

Roland,
You have not sent any comments to our patches that were sent few weeks 
ago on time for 2.6.32 inclusion,
and now I am surprised you do not accept them for 2.6.32.
I think we still have time to work together and fix your concerns on 
mlx4 driver.
Can you send more concrete comments so we can fix them?

Since we have a HW that supports SRIOV and many people are interested in 
this new technology for KVM thus it is important that we drive it now

Thanks
Tziporet
