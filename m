Return-Path: <linux-kernel-owner+w=401wt.eu-S1757933AbZC0Jpr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757933AbZC0Jpr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 05:45:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754327AbZC0Jph
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 05:45:37 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:59299 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754122AbZC0Jph (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 05:45:37 -0400
Message-ID: <49CCA029.40400@jp.fujitsu.com>
Date: Fri, 27 Mar 2009 18:45:13 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Andi Kleen <ak@linux.intel.com>
CC: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH -tip 2/3] x86, mce: Cleanup param parser
References: <49CB3F38.7090703@jp.fujitsu.com> <49CB4C7B.8080401@linux.intel.com>
In-Reply-To: <49CB4C7B.8080401@linux.intel.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> Hidetoshi Seto wrote:
>> - Fix the comment formatting.
>> - The error path does not return 0, and printk lacks level and "\n".
>> - Move __setup("nomce") next to mcheck_disable().
>> - Improve readability etc.
> 
> Looks good.

Thank you for reviewing!

This cleanup can stand alone, so could you apply this onto -tip?
# Or would you request me to resend it with subject stripped "2/3"?

Thanks,
H.Seto

