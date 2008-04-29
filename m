Return-Path: <linux-kernel-owner+w=401wt.eu-S1761142AbYD2UJl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761142AbYD2UJl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 16:09:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755370AbYD2UJc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 16:09:32 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54351 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754155AbYD2UJc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 16:09:32 -0400
Message-ID: <48178067.3030702@kernel.org>
Date: Tue, 29 Apr 2008 13:09:11 -0700
From: "H. Peter Anvin" <hpa@kernel.org>
Organization: Linux Kernel Organization, Inc.
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Willy Tarreau <w@1wt.eu>
CC: Adrian Bunk <bunk@kernel.org>, linux-kernel@vger.kernel.org,
       trivial@kernel.org
Subject: Re: [2.6 patch] UTF-8 fixes in comments
References: <20080428154023.GU2813@cs181133002.pp.htv.fi> <20080428230524.GK8474@1wt.eu> <48167A07.4000305@kernel.org> <20080429050605.GA27875@1wt.eu> <20080429072911.GA28059@cs181133002.pp.htv.fi> <20080429081423.GD30507@1wt.eu> <48177775.4000306@kernel.org> <20080429200505.GA15596@1wt.eu>
In-Reply-To: <20080429200505.GA15596@1wt.eu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Willy Tarreau wrote:
> 
>> konsole works fine with UTF-8 (I use it 
>> that way every day); the most common cause of this kind of problems is 
>> people explicitly clobbering the locale or charset class defaults in 
>> their login scripts.
> 
> I really doubt the miss would have done this. Or someone would have done
> it for her which I really doubt in such a small time frame after a fresh
> install from the day before. I will investigate though.
> 

 From one of Alan's posts it sounds like there was a bug with multibyte 
characters in readline at some point that got fixed relatively quickly, 
but still made it out.

	-hpa
