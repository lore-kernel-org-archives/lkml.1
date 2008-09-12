Return-Path: <linux-kernel-owner+w=401wt.eu-S1756095AbYILM0T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756095AbYILM0T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2008 08:26:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753146AbYILM0K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Sep 2008 08:26:10 -0400
Received: from mtagate2.de.ibm.com ([195.212.17.162]:60306 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752852AbYILM0J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2008 08:26:09 -0400
Message-ID: <48CA5EEB.4090809@linux.vnet.ibm.com>
Date: Fri, 12 Sep 2008 14:22:03 +0200
From: Pierre Morel <pmorel@linux.vnet.ibm.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20061206)
MIME-Version: 1.0
To: Dave Hansen <dave@linux.vnet.ibm.com>
CC: Oleg Nesterov <oleg@tv-sign.ru>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Roland McGrath <roland@redhat.com>,
       Heiko Carstens <heicars2@linux.vnet.ibm.com>,
       sameske@linux.vnet.ibm.com, Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, gregkh@suse.de,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>,
       Cedric Le Goater <clg@fr.ibm.com>, Daniel Lezcano <dlezcano@fr.ibm.com>
Subject: Re: [PATCH 1/1] system call notification with self_ptrace
References: <48C51439.7000706@linux.vnet.ibm.com> <20080909124302.GA139@tv-sign.ru> <48C7E3A9.3060602@linux.vnet.ibm.com> <20080910162008.GA401@tv-sign.ru> <1221063805.6781.11.camel@nimitz>
In-Reply-To: <1221063805.6781.11.camel@nimitz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dave,

be optimistic, why not?
I bet we will ;)

Pierre

Dave Hansen wrote:
> On Wed, 2008-09-10 at 20:20 +0400, Oleg Nesterov wrote:
>   
>> But... well, I think we need Roland's opinion. I must admit, I am a bit
>> sceptical about this patch ;) I mean, I don't really understand why it
>> is useful
>>     
>
> Yeah, I don't think they're completely coming clean on it, yet.  
>
> -- Dave
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>   


-- 
=============
Pierre Morel
RTOS and Embedded Linux

