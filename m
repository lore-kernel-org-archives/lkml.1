Return-Path: <linux-kernel-owner+w=401wt.eu-S1754891AbXHSHjp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754891AbXHSHjp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2007 03:39:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750967AbXHSHjh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Aug 2007 03:39:37 -0400
Received: from il.qumranet.com ([82.166.9.18]:41841 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750709AbXHSHjg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2007 03:39:36 -0400
Message-ID: <46C7F3C5.1000805@qumranet.com>
Date: Sun, 19 Aug 2007 10:39:49 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Laurent Vivier <Laurent.Vivier@bull.net>
CC: kvm-devel <kvm-devel@lists.sourceforge.net>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       virtualization <virtualization@lists.linux-foundation.org>
Subject: Re: [kvm-devel] [PATCH/RFC 4/4,	second shot]KVM uses "account_guest_time()"
References: <46C4719A.2060308@bull.net>	<46C4720F.7030304@bull.net>		<46C4725A.4070607@bull.net>	<46C4740F.2050701@bull.net>		<1187303955.6449.7.camel@localhost.localdomain>	<46C54FB8.7050504@bull.net>	<1187339450.6449.115.camel@localhost.localdomain>	<46C56774.2030009@bull.net>	<46C58BD5.3090207@bull.net> <46C58C8C.3080803@bull.net> <46C59C92.40902@qumranet.com> <46C59FA6.7020601@bull.net>
In-Reply-To: <46C59FA6.7020601@bull.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Laurent Vivier wrote:
>> Other way round.  In the patch that adds account_guest_time(), have a
>> CONFIG_GUEST_ACCOUNTING (defaulting to n, with no description, help, or
>> dependencies.  Then, CONFIG_KVM can select GUEST_ACCOUNTING.
>>     
>
> I was wondering in which Kconfig I can put it...
>
>   

Looks like init/Kconfig has similar stuff.

-- 
error compiling committee.c: too many arguments to function

