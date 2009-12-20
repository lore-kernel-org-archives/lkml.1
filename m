Return-Path: <linux-kernel-owner+w=401wt.eu-S1755922AbZLTSEk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755922AbZLTSEk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Dec 2009 13:04:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755838AbZLTSEj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Dec 2009 13:04:39 -0500
Received: from smtp5-g21.free.fr ([212.27.42.5]:41243 "EHLO smtp5-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755832AbZLTSEi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Dec 2009 13:04:38 -0500
Message-ID: <4B2E6729.1090102@free.fr>
Date: Sun, 20 Dec 2009 19:04:25 +0100
From: Bernard Pidoux <bpidoux@free.fr>
User-Agent: Thunderbird 2.0.0.23 (X11/20090822)
MIME-Version: 1.0
To: Jarek Poplawski <jarkao2@gmail.com>
CC: Bernard Pidoux <bernard.pidoux@upmc.fr>, linux-kernel@vger.kernel.org,
       Linux Netdev List <netdev@vger.kernel.org>,
       "David S. Miller" <davem@davemloft.net>
Subject: Re: kernel BUG at kernel/timer.c:951!
References: <4B2CD772.1030106@upmc.fr> <4B2D1025.1020106@gmail.com>
In-Reply-To: <4B2D1025.1020106@gmail.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jarek,

Your patch seemed to be working well until 2.6.31.6 kernel.
I did not apply your patch to kernel 2.6.32.
I agree that this may explain why these kernel panics are back.
I will apply this patch to 2.6.32.2 and will report the results soon.
Thanks.

Bernard Pidoux

Jarek Poplawski a écrit :
> Bernard Pidoux wrote, On 12/19/2009 02:38 PM:
> 
>> I am experiencing a few kernel panics on my Linux system using 2.6.32 and 2.6.32.1 kernels
>> with nosmp. 
> 
> Some of these oopses look similarly to those:
> http://markmail.org/message/scjov36zm2wf2ytv
> 
> How about this patch I sent you for testing?:
> http://markmail.org/message/nymi7xyd5c43hyfu
> 
> Jarek P.
> 
> 

