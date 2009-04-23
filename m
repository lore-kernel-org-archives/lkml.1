Return-Path: <linux-kernel-owner+w=401wt.eu-S1758243AbZDWUu3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758243AbZDWUu3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 16:50:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754332AbZDWUuO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 16:50:14 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52639 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754086AbZDWUuN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 16:50:13 -0400
Message-ID: <49F0D45D.3000706@zytor.com>
Date: Thu, 23 Apr 2009 13:49:33 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Huang Ying <ying.huang@intel.com>
CC: Andi Kleen <andi@firstfloor.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "mingo@elte.hu" <mingo@elte.hu>,
       "tglx@linutronix.de" <tglx@linutronix.de>
Subject: Re: [PATCH] [4/4] x86: MCE: Fix EIPV behaviour with !PCC
References: <20090407506.675031434@firstfloor.org>	 <20090407150657.61C4E1D046E@basil.firstfloor.org> <1240479838.6842.555.camel@yhuang-dev.sh.intel.com>
In-Reply-To: <1240479838.6842.555.camel@yhuang-dev.sh.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Huang Ying wrote:
> Add some description for the patch, hope that to be more clear.

The patch description makes sense.  I cannot, however, make head or tail 
out of the subject line or how it is related to the patch at all?

I have rewritten it to "always panic on tolerant == 0", ok with everyone?

	-hpa
