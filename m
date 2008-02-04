Return-Path: <linux-kernel-owner+w=401wt.eu-S1755609AbYBDEjS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755609AbYBDEjS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2008 23:39:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752083AbYBDEjJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Feb 2008 23:39:09 -0500
Received: from mga07.intel.com ([143.182.124.22]:52443 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751465AbYBDEjI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2008 23:39:08 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,299,1199692800"; 
   d="scan'208";a="374744738"
Message-ID: <47A69515.9000907@linux.intel.com>
Date: Sun, 03 Feb 2008 20:31:17 -0800
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Thunderbird 1.5.0.14 (Windows/20071210)
MIME-Version: 1.0
To: Dmitry Adamushko <dmitry.adamushko@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: latencytop: optimize LT_BACKTRACEDEPTH loops a bit
References: <1202074439.4765.7.camel@earth>
In-Reply-To: <1202074439.4765.7.camel@earth>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dmitry Adamushko wrote:
> ---
> 
> Subject: latencytop: optimize LT_BACKTRACEDEPTH loops a bit.
> 
> It looks like there is no need to loop any longer when 'same == 0'.
> 
> 
> Signed-off-by: Dmitry Adamushko <dmitry.adamushko@gmail.com>

looks good to me; Ingo can you queue this one up ?
