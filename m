Return-Path: <linux-kernel-owner+w=401wt.eu-S1751884AbZLVK2m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751884AbZLVK2m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Dec 2009 05:28:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751677AbZLVK2l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Dec 2009 05:28:41 -0500
Received: from mga05.intel.com ([192.55.52.89]:21941 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751611AbZLVK2l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Dec 2009 05:28:41 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,434,1257148800"; 
   d="scan'208";a="758359087"
Message-ID: <4B309F56.9020400@linux.intel.com>
Date: Tue, 22 Dec 2009 11:28:38 +0100
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.1.5) Gecko/20091204 Thunderbird/3.0
MIME-Version: 1.0
To: Stephen Hemminger <shemminger@linux-foundation.org>
CC: Mike Garrison <mcgarr@umich.edu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Len Brown <len.brown@intel.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Corrado Zoccolo <czoccolo@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.32.2: undefined reference to `__udivdi3'
References: <61FF0336-4E17-4EE5-9471-01360A6F7D29@umich.edu> <20091221122121.6853d68c@nehalam>
In-Reply-To: <20091221122121.6853d68c@nehalam>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/21/2009 21:21, Stephen Hemminger wrote:
> The new menu governor driver is written by Intel folks who never use 32-bit
> anymore it seems :-)

more like "by people who use a compiler that knows how to divide by a power of 2" :)

