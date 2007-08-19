Return-Path: <linux-kernel-owner+w=401wt.eu-S1755460AbXHSHlb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755460AbXHSHlb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2007 03:41:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751214AbXHSHlY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Aug 2007 03:41:24 -0400
Received: from il.qumranet.com ([82.166.9.18]:41847 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750709AbXHSHlX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2007 03:41:23 -0400
Message-ID: <46C7F42F.1080900@qumranet.com>
Date: Sun, 19 Aug 2007 10:41:35 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Laurent Vivier <Laurent.Vivier@bull.net>
CC: Rusty Russell <rusty@rustcorp.com.au>,
       kvm-devel <kvm-devel@lists.sourceforge.net>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       virtualization <virtualization@lists.linux-foundation.org>
Subject: Re: [kvm-devel] [PATCH/RFC 3/4]Introduce "account modifiers"	mechanism
References: <46C4719A.2060308@bull.net> <46C4720F.7030304@bull.net>		<46C4725A.4070607@bull.net> <46C4740F.2050701@bull.net>		<1187303955.6449.7.camel@localhost.localdomain>	<46C54FB8.7050504@bull.net>	<1187339450.6449.115.camel@localhost.localdomain> <46C56774.2030009@bull.net> <46C59AB1.6070505@qumranet.com> <46C59DC6.4020308@bull.net>
In-Reply-To: <46C59DC6.4020308@bull.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Laurent Vivier wrote:
>> So I think it is okay to have the same limitation for guest time.
>>     
>
> OK, so we can go back to my first patch.
> Who can decide to introduce this into the kernel ?
>   

The sched.c parts are best merged by Ingo, and I can carry the kvm 
parts.  Alternatively, I can carry the entire patchset if Ingo acks it.

-- 
error compiling committee.c: too many arguments to function

