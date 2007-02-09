Return-Path: <linux-kernel-owner+w=401wt.eu-S1946431AbXBIM7q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946431AbXBIM7q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 07:59:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946433AbXBIM7q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 07:59:46 -0500
Received: from tristate.vision.ee ([194.204.30.144]:59550 "HELO mail.city.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1946431AbXBIM7p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 07:59:45 -0500
Message-ID: <45CC703F.9090302@vision.ee>
Date: Fri, 09 Feb 2007 14:59:43 +0200
From: =?UTF-8?B?TGVuYXIgTMO1aG11cw==?= <lenar@vision.ee>
User-Agent: Thunderbird 1.5.0.9 (X11/20070102)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: -mm merge plans for 2.6.21
References: <20070208150710.1324f6b4.akpm@linux-foundation.org>	<45CC44D5.6050602@vision.ee> <20070209021242.03ba88d8.akpm@linux-foundation.org>
In-Reply-To: <20070209021242.03ba88d8.akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Fri, 09 Feb 2007 11:54:29 +0200 Lenar Lõhmus <lenar@vision.ee> wrote:
> Has it?  I don't think I've ever observed any benefits from it and I don't
> think anyone has ever got down and worked out what its drawbacks might be,
> and seen if they can be demonstrated in practice.
>   
Who should get down? It seems no serious kernel developer cares enough
to get to it. It's just a desktop feature you know - no big iron - 
uninteresting.
>> Why keep it in -mm for so long?
>>     
>
> I'm waiting to be shown that its benefits exceed its costs.  Sometimes
> that's hard.
>   
Swap prefetch and those mystic _costs_. But nobody
hasn't communicated loud and clear what those costs are. I imagine
it must be really hard to fight to something you don't even exists.
Or prove that you are better than somebody you have never seen or heard of.

Please somebody qualified, take the time, dig that code, and show us 
those costs.
With details. So Con can make the code even better and included in 
mainline or
drop altogether if it's really bad and move on to other endeavours.

With best,
Lenar

