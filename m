Return-Path: <linux-kernel-owner+w=401wt.eu-S933606AbYD3W30@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933606AbYD3W30 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 18:29:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765240AbYD3W3E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 18:29:04 -0400
Received: from gw.goop.org ([64.81.55.164]:41390 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765154AbYD3W3D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 18:29:03 -0400
Message-ID: <4818F2A0.10402@goop.org>
Date: Wed, 30 Apr 2008 15:28:48 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080418)
MIME-Version: 1.0
To: "Christopher S. Aker" <caker@theshore.net>
CC: linux-kernel@vger.kernel.org
Subject: Re: pvops - xen - unable to handle kernel paging request
References: <480CC04C.2020100@theshore.net> <480FCD33.5090303@goop.org>
In-Reply-To: <480FCD33.5090303@goop.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> Christopher S. Aker wrote:
>> Xen: 3.2.1-rc5 64bit
>> dom0: 2.6.16.38 PAE
>> domU: 2.6.25 PAE  
>> BUG: unable to handle kernel paging request at 15c38554
>> IP: [<c0103195>] xen_make_pte+0x45/0x50
>> Oops: 0000 [#1] SMP
>> Modules linked in:
>
> Hi Chris,
>
> How easy is this to reproduce?  Is this immediate or under load?
>
> How much memory does the host machine have?  How much allocated to the 
> domain?
>
> And to be clear, this is plain 2.6.25, not 2.6.25+mergewindow, right?
>
> (BTW, it would help if you cc: me on Xen bug reports, since I don't 
> necessarily catch up on lkml traffic very quickly.)
>
> Thanks,
>    J
>

Ping?

    J
