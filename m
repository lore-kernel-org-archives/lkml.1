Return-Path: <linux-kernel-owner+w=401wt.eu-S1754029AbYIGEr1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754029AbYIGEr1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Sep 2008 00:47:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750924AbYIGErS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Sep 2008 00:47:18 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53771 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750864AbYIGErR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Sep 2008 00:47:17 -0400
Message-ID: <48C35CA9.4010205@zytor.com>
Date: Sat, 06 Sep 2008 21:46:33 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Steven Noonan <steven.noonan@uplinklabs.net>
CC: Alain Knaff <alain@knaff.lu>, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] init: bzip2 or lzma -compressed kernels and initrds
References: <200809062119.m86LJ5Of026101@hitchhiker.org.lu>	 <48C34803.60006@zytor.com> <1a6b76aa0809062135n4d0710c7sf7332d6b4e63cdad@mail.gmail.com>
In-Reply-To: <1a6b76aa0809062135n4d0710c7sf7332d6b4e63cdad@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Noonan wrote:
> On Sat, Sep 6, 2008 at 8:18 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>> Alain Knaff wrote:
>>> This version applies to kernel 2.6.26.3
>>>
>> Could you produce a version against the -tip tree, either the master branch
>> or the x86/setup branch?
> 
> I second this.
> 
> I tested the existing patch, and it works great when applied to
> 2.6.26. It'd be great to see a version of this either go into -mm or
> mainline sometime soon.
> 

I should warn that I looked over the patch, and it looks quite messy. 
It may need structural cleanup before integration.

	-hpa
