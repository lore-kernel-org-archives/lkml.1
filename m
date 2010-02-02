Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754007Ab0BBB7l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 20:59:41 -0500
Received: from terminus.zytor.com ([198.137.202.10]:54061 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751011Ab0BBB7j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 20:59:39 -0500
Message-ID: <4B6786F2.9010307@zytor.com>
Date: Mon, 01 Feb 2010 17:59:14 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Thunderbird/3.0.1
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de,
       fengguang.wu@intel.com, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/mm] Generic page_is_ram: use __weak
References: <tip-e52730071567ec5b6f57e21d6693b112e01e1d0e@git.kernel.org>	<20100201172423.6803e898.akpm@linux-foundation.org>	<4B6781D3.6090904@zytor.com> <20100201175506.5a0b01c1.akpm@linux-foundation.org>
In-Reply-To: <20100201175506.5a0b01c1.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/01/2010 05:55 PM, Andrew Morton wrote:
> 
> Nobody's complained so far:
> 
> y:/usr/src/git26> git log | grep '\[.*@.*:' | wc -l
> 2434
> 
> It's a tradeoff between being nice to authors versus tree-cleanliness
> and bisectability.
> 

Yes, if it had broken the tree in between the patches I would have
folded them.

	-hpa

