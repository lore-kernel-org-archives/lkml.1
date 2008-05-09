Return-Path: <linux-kernel-owner+w=401wt.eu-S1760547AbYEIXi5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760547AbYEIXi5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 19:38:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760155AbYEIXia
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 19:38:30 -0400
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:45549 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760062AbYEIXi3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 19:38:29 -0400
X-Greylist: delayed 1014 seconds by postgrey-1.27 at vger.kernel.org; Fri, 09 May 2008 19:38:29 EDT
Date: Fri, 09 May 2008 16:21:33 -0700
From: Matheos Worku <Matheos.Worku@Sun.COM>
Subject: Re: NIU - Sun Neptune 10g - Transmit timed out reset (2.6.24)
In-reply-to: <4824D9CD.4050402@krogh.cc>
To: Jesper Krogh <jesper@krogh.cc>
Cc: David Miller <davem@davemloft.net>, yhlu.kernel@gmail.com,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Message-id: <4824DC7D.6000305@sun.com>
MIME-version: 1.0
Content-type: text/plain; format=flowed; charset=ISO-8859-1
Content-transfer-encoding: 7BIT
References: <86802c440805071130m62c1f4edydb3316dac4a2aba2@mail.gmail.com>
 <20080507.141521.193714938.davem@davemloft.net> <482498D5.9060008@krogh.cc>
 <20080509.143229.174354251.davem@davemloft.net> <4824C936.9000103@krogh.cc>
 <4824CBA1.8040703@sun.com> <4824CCF0.5050302@krogh.cc>
 <4824D1E1.10007@sun.com> <4824D39B.6040006@sun.com> <4824D9CD.4050402@krogh.cc>
User-Agent: Thunderbird 2.0.0.12 (Windows/20080213)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jesper Krogh wrote:
> Matheos Worku wrote:
>>>> Thats a transmit.. from the NFS server to the clients.
>>>
>> Is MSI/MSI-X enabled on the kernel? I have noticed that it was not 
>> enabled on Gutsy-SPARC?
> 
> # grep MSI .config
> CONFIG_ARCH_SUPPORTS_MSI=y
> CONFIG_PCI_MSI=y
> 
> Should that be ok?
> 
That should be ok.

