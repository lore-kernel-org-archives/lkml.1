Return-Path: <linux-kernel-owner+w=401wt.eu-S1761348AbXKHQkY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761348AbXKHQkY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2007 11:40:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757649AbXKHQkN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Nov 2007 11:40:13 -0500
Received: from gw.goop.org ([64.81.55.164]:36951 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755715AbXKHQkM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2007 11:40:12 -0500
Message-ID: <47333BCF.5050503@goop.org>
Date: Thu, 08 Nov 2007 08:39:43 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Glauber de Oliveira Costa <glommer@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Zach Amsden <zach@vmware.com>,
       Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com>
Subject: Re: [PATCH RFC 2/7] x86: clean up mm/init_32.c
References: <20071108015008.660012621@goop.org>	 <20071108015310.059598778@goop.org> <5d6222a80711080820j5e095e12k7fd1f1710cd1bd24@mail.gmail.com>
In-Reply-To: <5d6222a80711080820j5e095e12k7fd1f1710cd1bd24@mail.gmail.com>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Glauber de Oliveira Costa wrote:
>> -                       /* Map with big pages if possible, otherwise create normal page tables. */
>> +                       /* Map with big pages if possible, otherwise
>> +                          create normal page tables. */
>>     
> /*
>  * multi comment lines are preferred
>  * this way, IIRC ;-)
>  */
>   

I don't think it's worth turning a one-liner into a great big banner.

    J
