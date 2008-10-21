Return-Path: <linux-kernel-owner+w=401wt.eu-S1755879AbYJUWUa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755879AbYJUWUa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 18:20:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751625AbYJUWUU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 18:20:20 -0400
Received: from ipmail01.adl6.internode.on.net ([203.16.214.146]:7405 "EHLO
	ipmail01.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751179AbYJUWUT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 18:20:19 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AnsDAM8S9kg7p+/xgWdsb2JhbACBcpFuAQEWIq4MgWs
X-IronPort-AV: E=Sophos;i="4.33,460,1220193000"; 
   d="scan'208";a="215378366"
Message-ID: <48FE559F.4040404@call-direct.com.au>
Date: Wed, 22 Oct 2008 08:20:15 +1000
From: Iwo Mergler <iwo@call-direct.com.au>
User-Agent: Thunderbird 2.0.0.12 (X11/20080302)
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: linux-kernel@vger.kernel.org, Jes Sorensen <jes@trained-monkey.org>
Subject: Re: Fix for genalloc locking
References: <48F83400.90901@call-direct.com.au> <20081021083949.3b1473c8.randy.dunlap@oracle.com>
In-Reply-To: <20081021083949.3b1473c8.randy.dunlap@oracle.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Randy Dunlap wrote:
> On Fri, 17 Oct 2008 16:43:12 +1000 Iwo Mergler wrote:
>> BTW, is there any documentation on the Lockdep warnings?
>> What exactly is the meaning of {--+.} in 
>>
>> (&pool->lock){--+.}, at: [<c0125d1c>] gen_pool_free+0x34/0x120
> 
> Did you read Documentation/lockdep-design.txt ?
> 

No, I didn't. Selective blindness. Thanks for the hint.

Kind regards,

Iwo

