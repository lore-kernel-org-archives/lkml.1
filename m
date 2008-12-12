Return-Path: <linux-kernel-owner+w=401wt.eu-S1759382AbYLLQxg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759382AbYLLQxg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2008 11:53:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757694AbYLLQx2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Dec 2008 11:53:28 -0500
Received: from smtp-02.mandic.com.br ([200.225.81.133]:42755 "EHLO
	smtp-02.mandic.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757520AbYLLQx2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2008 11:53:28 -0500
Message-ID: <49429705.2010205@diamondcut.com.br>
Date: Fri, 12 Dec 2008 14:53:25 -0200
From: "Renato S. Yamane" <yamane@diamondcut.com.br>
User-Agent: Thunderbird 2.0.0.18 (X11/20081105)
MIME-Version: 1.0
To: Jon Masters <jonathan@jonmasters.org>
CC: Marcello Henrique <faraohh@gmail.com>, linux-kernel@vger.kernel.org,
       gregkh@suse.de
Subject: Re: Auto generate .config.
References: <f5cc88f60812120747w47c762a7qcee62fdfa10d6ac6@mail.gmail.com>	 <49428DF8.2090205@diamondcut.com.br>	 <f5cc88f60812120820i4252962er2fa6d3483c2ae412@mail.gmail.com> <1229099699.7923.4.camel@jcmlaptop>
In-Reply-To: <1229099699.7923.4.camel@jcmlaptop>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jon Masters wrote:
> Marcello Henrique wrote:
>> I understand that this is possible, but would not be possible to
>> generate one .config of modules that are running to compile a kernel
>> optimized?
>>
>> The idea is that the kernel of my distribution is too fat and I only
>> generate a kernel module that I use automatically from a kernel fat.
>> understand?
> 
> Several people have written scripts over the years to do this. I don't
> have one handy, but I suspect the LKML (linux-kernel) archives know.

Greg wrote a good script in book "Linux Kernel in a Nutshell" to find a
lot of modules used in your current kernel:
<http://www.kroah.com/lkn>

Take a look in chapter 07:
<http://www.kernel.org/pub/linux/kernel/people/gregkh/lkn/lkn_pdf/ch07.pdf>

Maybe I'm wrong, but I think that I see in the past an errata about this
script in O'realy.

Best regards,
Renato
