Return-Path: <linux-kernel-owner+w=401wt.eu-S1759774AbYESWdF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759774AbYESWdF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 18:33:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759238AbYESWck
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 18:32:40 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57444 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758835AbYESWck (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 18:32:40 -0400
Message-ID: <4831FF3F.50800@zytor.com>
Date: Mon, 19 May 2008 15:29:19 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Harvey Harrison <harvey.harrison@gmail.com>
CC: Adrian Bunk <bunk@kernel.org>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [2.6 patch] asm-generic/int-ll64.h: always provide __{s,u}64
References: <20080519215452.GK17716@cs181133002.pp.htv.fi>	 <4831F89F.5060106@zytor.com> <1211236048.5915.94.camel@brick>
In-Reply-To: <1211236048.5915.94.camel@brick>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Harvey Harrison wrote:
> 
> If it is going to be unconditionally offered, we could get rid of
> __BYTEORDER_HAS_U64__ as a next step.  Unless there is something I've
> missed.
> 

That would be good, too.

	-hpa
