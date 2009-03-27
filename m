Return-Path: <linux-kernel-owner+w=401wt.eu-S1751988AbZC0Ld6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751988AbZC0Ld6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 07:33:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750913AbZC0Lds
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 07:33:48 -0400
Received: from mga06.intel.com ([134.134.136.21]:18516 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750883AbZC0Lds (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 07:33:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,431,1233561600"; 
   d="scan'208";a="398036765"
Message-ID: <49CCB9B7.3040902@linux.intel.com>
Date: Fri, 27 Mar 2009 12:34:15 +0100
From: Andi Kleen <ak@linux.intel.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
CC: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH -tip 2/3] x86, mce: Cleanup param parser
References: <49CB3F38.7090703@jp.fujitsu.com> <49CB4C7B.8080401@linux.intel.com> <49CCA029.40400@jp.fujitsu.com>
In-Reply-To: <49CCA029.40400@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hidetoshi Seto wrote:
> Andi Kleen wrote:
>> Hidetoshi Seto wrote:
>>> - Fix the comment formatting.
>>> - The error path does not return 0, and printk lacks level and "\n".
>>> - Move __setup("nomce") next to mcheck_disable().
>>> - Improve readability etc.
>> Looks good.
> 
> Thank you for reviewing!
> 
> This cleanup can stand alone, so could you apply this onto -tip?
> # Or would you request me to resend it with subject stripped "2/3"?


I can add it into my pile. I don't have direct access to tip

-Andi
