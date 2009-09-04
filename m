Return-Path: <linux-kernel-owner+w=401wt.eu-S932640AbZIDPri@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932640AbZIDPri (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 11:47:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932300AbZIDPrh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 11:47:37 -0400
Received: from claw.goop.org ([74.207.240.146]:44170 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932144AbZIDPrh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 11:47:37 -0400
Message-ID: <4AA1369A.5040204@goop.org>
Date: Fri, 04 Sep 2009 08:47:38 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Lightning/1.0pre Thunderbird/3.0b3
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: "H. Peter Anvin" <hpa@zytor.com>, Xiao Guangrong <ericxiao.gr@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Jens Axboe <jens.axboe@oracle.com>,
       Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org, x86@kernel.org,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] x86: reuse the boot-time mappings of fixed_addresses
References: <4A90AADE.20307@gmail.com> <20090829110046.GA6812@elte.hu> <4A997088.60908@zytor.com> <20090831082632.GB15619@elte.hu> <4A9C6ADF.2020707@goop.org> <20090904073355.GA20598@elte.hu>
In-Reply-To: <20090904073355.GA20598@elte.hu>
X-Enigmail-Version: 0.97a
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/04/09 00:33, Ingo Molnar wrote:
>> It hardly seems worth it, but I guess it isn't much code. [...]
>>     
> Ok, i understood this as an Acked-by from you - lemme know if that's 
> wrong ;-)
>   

That's a bit proactive.  It's more "Meh-I-suppose-d-by: ".

    J
