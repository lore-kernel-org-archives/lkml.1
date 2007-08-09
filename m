Return-Path: <linux-kernel-owner+w=401wt.eu-S1753185AbXHIVkz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753185AbXHIVkz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 17:40:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752567AbXHIVk1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 17:40:27 -0400
Received: from mga05.intel.com ([192.55.52.89]:54417 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751012AbXHIVkY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 17:40:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.19,243,1183359600"; 
   d="scan'208";a="278950964"
Message-ID: <46BB89C0.4040303@ichips.intel.com>
Date: Thu, 09 Aug 2007 14:40:16 -0700
From: Sean Hefty <mshefty@ichips.intel.com>
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
MIME-Version: 1.0
To: Steve Wise <swise@opengridcomputing.com>
CC: Roland Dreier <rdreier@cisco.com>, "David S. Miller" <davem@davemloft.net>,
       netdev@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>,
       OpenFabrics General <general@lists.openfabrics.org>
Subject: Re: [ofa-general] Re: [PATCH RFC] RDMA/CMA: Allocate PS_TCP ports
 from the host TCP port space.
References: <46B883B5.8040702@opengridcomputing.com> <46BB61D0.4090101@opengridcomputing.com>
In-Reply-To: <46BB61D0.4090101@opengridcomputing.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Steve Wise wrote:
> Any more comments?

Does anyone have ideas on how to reserve the port space without using a 
struct socket?

- Sean
