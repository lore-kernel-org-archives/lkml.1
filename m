Return-Path: <linux-kernel-owner+w=401wt.eu-S1755270AbYE2DmN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755270AbYE2DmN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 23:42:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752848AbYE2Dl7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 23:41:59 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:61296 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752784AbYE2Dl6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 23:41:58 -0400
Message-ID: <483E25D4.6090809@cn.fujitsu.com>
Date: Thu, 29 May 2008 11:41:08 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Paul Jackson <pj@sgi.com>
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, menage@google.com
Subject: Re: [RFC] [PATCH] cpusets: update tasks' cpus_allowed and mems_allowed
 after CPU/NODE offline/online
References: <483E1D77.30400@cn.fujitsu.com> <20080528223353.61affb22.pj@sgi.com>
In-Reply-To: <20080528223353.61affb22.pj@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

on 2008-5-29 11:33 Paul Jackson wrote:
> Miao wrote:
>> Though the patch is a little big, most of the change is just code restruction.
> 
> This looks like a nice bug fix - thanks!
> 
> Allow me to ask a question, but I hope you will be happy to answer yes
> or no, either way, as you see it.
> 
> The question is:
> 
>   Would it be easy to split this patch into two pieces, where:
>   1) the first piece contains the restructuring (but is still buggy), and
>   2) the second piece has just the bug fix?
> 

ok, I will do it.

Miao Xie

> If that would be easy, that might make a nice way to present this fix.
> 
> If that would not be so easy, that's ok ... I can still review easily
> enough.  I'll just have to drink an extra cup of coffee first, to make
> my mind a little more alert <grin>.
> 

