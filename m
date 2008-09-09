Return-Path: <linux-kernel-owner+w=401wt.eu-S1756230AbYIIN1P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756230AbYIIN1P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 09:27:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753852AbYIIN1A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 09:27:00 -0400
Received: from il.qumranet.com ([212.179.150.194]:35742 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753649AbYIIN07 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 09:26:59 -0400
Message-ID: <48C679A2.7070100@qumranet.com>
Date: Tue, 09 Sep 2008 16:26:58 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Sheng Yang <sheng.yang@intel.com>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andi Kleen <ak@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 2/2] x86: Extended cpuinfo to show virtualization HW features
References: <12209432941440-git-send-email-sheng.yang@intel.com> <1220943294312-git-send-email-sheng.yang@intel.com>
In-Reply-To: <1220943294312-git-send-email-sheng.yang@intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sheng Yang wrote:
> The hardware virtualization technology evolves very fast. But currently
> it's hard to tell if your CPU support a certain kind of HW technology
> without digging into the source code.
>
> The patch add a new catagory in "flags" under /proc/cpuinfo. Now "flags"
> can indicate the (important) HW virtulization features the CPU supported
> as well.
>
> Current implementation just cover Intel VMX side.
>   

I'm missing the strings that go into /proc/cpuinfo?

-- 
error compiling committee.c: too many arguments to function

