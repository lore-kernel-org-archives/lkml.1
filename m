Return-Path: <linux-kernel-owner+w=401wt.eu-S1753685Ab0ARPMS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753685Ab0ARPMS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 10:12:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753564Ab0ARPMR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 10:12:17 -0500
Received: from mx1.redhat.com ([209.132.183.28]:1491 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752297Ab0ARPMP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 10:12:15 -0500
Message-ID: <4B547A31.4090106@redhat.com>
Date: Mon, 18 Jan 2010 17:11:45 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Thunderbird/3.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Gleb Natapov <gleb@redhat.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Pekka Enberg <penberg@cs.helsinki.fi>, linux-mm@kvack.org,
       kosaki.motohiro@jp.fujitsu.com, linux-kernel@vger.kernel.org,
       linux-api@vger.kernel.org, akpm@linux-foundation.org,
       andrew.c.morrow@gmail.com,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH v6] add MAP_UNLOCKED mmap flag
References: <20100118133755.GG30698@redhat.com>	 <84144f021001180609r4d7fbbd0p972d5bc0e227d09a@mail.gmail.com>	 <20100118141938.GI30698@redhat.com>	 <20100118143232.0a0c4b4d@lxorguk.ukuu.org.uk>	 <1263826198.4283.600.camel@laptop>  <20100118150159.GB14345@redhat.com> <1263827194.4283.609.camel@laptop>
In-Reply-To: <1263827194.4283.609.camel@laptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/18/2010 05:06 PM, Peter Zijlstra wrote:
> On Mon, 2010-01-18 at 17:01 +0200, Gleb Natapov wrote:
>    
>> There are valid uses for mlockall()
>>      
> That's debatable.
>
>    

Real-time?

-- 
error compiling committee.c: too many arguments to function

