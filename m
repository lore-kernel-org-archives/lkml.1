Return-Path: <linux-kernel-owner+w=401wt.eu-S1752661AbXHTHzu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752661AbXHTHzu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 03:55:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756484AbXHTHzl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 03:55:41 -0400
Received: from il.qumranet.com ([82.166.9.18]:45746 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757996AbXHTHzk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 03:55:40 -0400
Message-ID: <46C94908.5080008@qumranet.com>
Date: Mon, 20 Aug 2007 10:55:52 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Laurent Vivier <Laurent.Vivier@bull.net>
CC: Rusty Russell <rusty@rustcorp.com.au>,
       kvm-devel <kvm-devel@lists.sourceforge.net>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       virtualization <virtualization@lists.linux-foundation.org>
Subject: Re: [kvm-devel] [PATCH/RFC 3/4]Introduce "account modifiers" mechanism
References: <46C4719A.2060308@bull.net> <46C4720F.7030304@bull.net>		<46C4725A.4070607@bull.net> <46C4740F.2050701@bull.net>		<1187303955.6449.7.camel@localhost.localdomain>	<46C54FB8.7050504@bull.net>	<1187339450.6449.115.camel@localhost.localdomain> <46C56774.2030009@bull.net> <46C59AB1.6070505@qumranet.com> <46C5ACE8.2050004@bull.net> <46C7F362.80106@qumranet.com> <46C94306.8080300@bull.net>
In-Reply-To: <46C94306.8080300@bull.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Laurent Vivier wrote:
>>
>> Where did CONFIG_GUEST_ACCOUNTING go?
>>
>>     
>
> Lost in the sea ...
>
> Actually, I thought this modification is not enough expensive (in time and
> space) to justify a CONFIG_*. But if you think so I can add this in init/Kconfig.
>
>   

The difference between "convince everyone that it isn't expensive, 
including the embedded guys" and preemptively adding a config option can 
be quite large...

-- 
error compiling committee.c: too many arguments to function

