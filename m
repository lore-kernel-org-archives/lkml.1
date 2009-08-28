Return-Path: <linux-kernel-owner+w=401wt.eu-S1752858AbZH1T35@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752858AbZH1T35 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Aug 2009 15:29:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752789AbZH1T35
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Aug 2009 15:29:57 -0400
Received: from hera.kernel.org ([140.211.167.34]:58699 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752588AbZH1T34 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Aug 2009 15:29:56 -0400
Message-ID: <4A982FF2.8040001@kernel.org>
Date: Fri, 28 Aug 2009 12:28:50 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Rusty Russell <rusty@rustcorp.com.au>
CC: Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Zachary Amsden <zach@vmware.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Xiao Guangrong <xiaooguangrong@cn.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: linux-next: reservetop fix disables mem=
References: <Pine.LNX.4.64.0908241736520.32764@sister.anvils> <4A92D029.8090807@kernel.org> <20090824182713.GB9785@elte.hu>
In-Reply-To: <20090824182713.GB9785@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
>> and according to
>> http://lkml.org/lkml/2008/12/10/388
>> http://lkml.org/lkml/2008/12/10/456
>>
>> Zachary should split reserve_top_address() to two functions... 
>> before sending that patch to Linus
> 
> mind looking at this yourself if interested? Zachary has not been 
> active for quite some time.
> 


other ways is to revive the Rusty Russell's patchset that move paramater early...

YH
