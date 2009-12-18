Return-Path: <linux-kernel-owner+w=401wt.eu-S1754596AbZLRPuJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754596AbZLRPuJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 10:50:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752882AbZLRPuG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 10:50:06 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48868 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752744AbZLRPuD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 10:50:03 -0500
Date: Fri, 18 Dec 2009 07:47:53 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Peter Zijlstra <peterz@infradead.org>
cc: Tejun Heo <tj@kernel.org>, awalls@radix.net, linux-kernel@vger.kernel.org,
       jeff@garzik.org, mingo@elte.hu, akpm@linux-foundation.org,
       jens.axboe@oracle.com, rusty@rustcorp.com.au, cl@linux-foundation.org,
       dhowells@redhat.com, arjan@linux.intel.com, avi@redhat.com,
       johannes@sipsolutions.net, andi@firstfloor.org
Subject: Re: workqueue thing
In-Reply-To: <1261150788.20899.299.camel@laptop>
Message-ID: <alpine.LFD.2.00.0912180747030.3712@localhost.localdomain>
References: <1261141088-2014-1-git-send-email-tj@kernel.org>  <1261143924.20899.169.camel@laptop>  <alpine.LFD.2.00.0912180724580.3712@localhost.localdomain> <1261150788.20899.299.camel@laptop>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 18 Dec 2009, Peter Zijlstra wrote:
> 
> That's exactly what it does..
> 
> 4e6045f134784f4b158b3c0f7a282b04bd816887
> eb13ba873881abd5e15af784756a61af635e665e
> a67da70dc0955580665f5444f318b92e69a3c272

Ahh. Never even triggered my "I've seen those patches".

		Linus
