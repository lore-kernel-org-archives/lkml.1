Return-Path: <linux-kernel-owner+w=401wt.eu-S1758045AbXGJMIr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758045AbXGJMIr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 08:08:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754505AbXGJMIj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 08:08:39 -0400
Received: from mtagate8.de.ibm.com ([195.212.29.157]:48571 "EHLO
	mtagate8.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753552AbXGJMIi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 08:08:38 -0400
Message-ID: <469375F4.1010608@free.fr>
Date: Tue, 10 Jul 2007 14:05:08 +0200
From: Daniel Lezcano <daniel.lezcano@free.fr>
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: Pavel Emelianov <xemul@openvz.org>
CC: Cedric Le Goater <clg@fr.ibm.com>,
       Linux Containers <containers@lists.osdl.org>,
       Kirill Korotaev <dev@openvz.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/16] Pid namespaces
References: <468DF6F7.1010906@openvz.org>	<1184003180.21234.39.camel@dyn9047017100.beaverton.ibm.com>	<46929540.2090405@fr.ibm.com> <46936DC8.3050602@openvz.org>
In-Reply-To: <46936DC8.3050602@openvz.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Emelianov wrote:
> Cedric Le Goater wrote:
>> Badari Pulavarty wrote:
>>> On Fri, 2007-07-06 at 12:01 +0400, Pavel Emelianov wrote:
>>>> This is "submition for inclusion" of hierarchical, not kconfig
>>>> configurable, zero overheaded ;) pid namespaces.
>>> Not able to boot my ppc64 machine with the patchset :(
>> I can't boot either on a x86_64 but I don't even have logs to send :(

Did you tryed to append at the kernel command  line the parameter:

	earlyprintk=serial,ttyS0,keep

> 
> Neither can I. And I cannot boot clean 2.6.22-rc6-mm1 either :(
> Does someone already know what the reason is?
> 
>> C.
>>
> 
> _______________________________________________
> Containers mailing list
> Containers@lists.linux-foundation.org
> https://lists.linux-foundation.org/mailman/listinfo/containers

