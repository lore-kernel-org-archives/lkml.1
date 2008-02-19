Return-Path: <linux-kernel-owner+w=401wt.eu-S1761388AbYBSBAj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761388AbYBSBAj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 20:00:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758773AbYBSBAW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 20:00:22 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:49303 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1757705AbYBSBAT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 20:00:19 -0500
Message-ID: <47BA299A.3040207@cn.fujitsu.com>
Date: Tue, 19 Feb 2008 08:58:02 +0800
From: Shi Weihua <shiwh@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, Roland McGrath <roland@redhat.com>
Subject: Re: [PATCH 1/5] signal(x86_32): Improve the signal stack overflow
 check
References: <47B95C4D.6080000@cn.fujitsu.com> <20080218134720.GA28851@elte.hu>
In-Reply-To: <20080218134720.GA28851@elte.hu>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Ingo Molnar wrote::
> * Shi Weihua <shiwh@cn.fujitsu.com> wrote:
> 
>> We need to check for stack overflow only when the signal is on stack. 
>> So we can improve the patch "http://lkml.org/lkml/2007/11/27/101" as 
>> following.
> 
> hm, does this address Roland's observations at:
> 
>    http://lkml.org/lkml/2007/11/28/13
> 
> ?

Yes. please check it.

> 
> 	Ingo
> 
> 
> 

