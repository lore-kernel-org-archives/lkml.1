Return-Path: <linux-kernel-owner+w=401wt.eu-S1760529AbZD1Czi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760529AbZD1Czi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 22:55:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760158AbZD1CzV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 22:55:21 -0400
Received: from hera.kernel.org ([140.211.167.34]:51388 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758953AbZD1CzT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 22:55:19 -0400
Message-ID: <49F66FFF.8080207@kernel.org>
Date: Tue, 28 Apr 2009 11:54:55 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: axboe@kernel.dk, linux-kernel@vger.kernel.org, joerg@dorchain.net,
       geert@linux-m68k.org, donari75@gmail.com, jdike@linux.intel.com,
       benh@kernel.crashing.org, Laurent@lvivier.info
Subject: Re: [PATCH 05/12] sunvdc: kill vdc_end_request()
References: <1240489553-15724-1-git-send-email-tj@kernel.org>	<1240489553-15724-6-git-send-email-tj@kernel.org> <20090423.063332.154679155.davem@davemloft.net>
In-Reply-To: <20090423.063332.154679155.davem@davemloft.net>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 28 Apr 2009 02:53:56 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote:
> From: Tejun Heo <tj@kernel.org>
> Date: Thu, 23 Apr 2009 21:25:46 +0900
> 
>> vdc_end_request() is a thin silly wrapper on top of
>> __blk_end_request().  Kill it.
>>
>> [ Impact: cleanup ]
>>
>> Signed-off-by: Tejun Heo <tj@kernel.org>
> 
> Acked-by: David S. Miller <davem@davemloft.net>

Thanks.  Acked-by added to the patch.

-- 
tejun
