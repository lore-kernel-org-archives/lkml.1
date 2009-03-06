Return-Path: <linux-kernel-owner+w=401wt.eu-S1754604AbZCFJCn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754604AbZCFJCn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 04:02:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751939AbZCFJC3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 04:02:29 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:61688 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751010AbZCFJC2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 04:02:28 -0500
Message-ID: <49B0E6A9.9020702@cn.fujitsu.com>
Date: Fri, 06 Mar 2009 17:02:33 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Alexey Dobriyan <adobriyan@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [RFC][PATCH] kmemdup_from_user(): introduce
References: <49B0CAEC.80801@cn.fujitsu.com> <20090306082056.GB3450@x200.localdomain> <49B0DE89.9000401@cn.fujitsu.com> <20090306090313.GB4225@x200.localdomain>
In-Reply-To: <20090306090313.GB4225@x200.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> Why not if we have good reasons? And I don't think we can call this
>> "happen to" if there are 250+ of them?
> 
> Please, read through them. This "250+" number suddenly will become
> like 20, because wrapper is not good enough.
> 

I did read most of them roughly, and it will be at least 50.


