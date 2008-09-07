Return-Path: <linux-kernel-owner+w=401wt.eu-S1755430AbYIGHk5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755430AbYIGHk5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Sep 2008 03:40:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752478AbYIGHks
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Sep 2008 03:40:48 -0400
Received: from crmm.lgl.lu ([158.64.72.228]:50337 "EHLO lll.lu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752188AbYIGHkr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Sep 2008 03:40:47 -0400
Message-ID: <48C38571.7060808@knaff.lu>
Date: Sun, 07 Sep 2008 09:40:33 +0200
From: Alain Knaff <alain@knaff.lu>
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Steven Noonan <steven.noonan@uplinklabs.net>,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] init: bzip2 or lzma -compressed kernels and initrds
References: <200809062119.m86LJ5Of026101@hitchhiker.org.lu>	 <48C34803.60006@zytor.com> <1a6b76aa0809062135n4d0710c7sf7332d6b4e63cdad@mail.gmail.com> <48C35CA9.4010205@zytor.com>
In-Reply-To: <48C35CA9.4010205@zytor.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> Steven Noonan wrote:
>> On Sat, Sep 6, 2008 at 8:18 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>>> Alain Knaff wrote:
>>>> This version applies to kernel 2.6.26.3
>>>>
>>> Could you produce a version against the -tip tree, either the master
>>> branch
>>> or the x86/setup branch?
>>
>> I second this.
>>
>> I tested the existing patch, and it works great when applied to
>> 2.6.26. It'd be great to see a version of this either go into -mm or
>> mainline sometime soon.
>>
> 
> I should warn that I looked over the patch, and it looks quite messy. It
> may need structural cleanup before integration.
> 
>     -hpa

Could you elaborate please?

Alain

