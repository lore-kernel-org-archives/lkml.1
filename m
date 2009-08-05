Return-Path: <linux-kernel-owner+w=401wt.eu-S1752997AbZHEXfU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752997AbZHEXfU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 19:35:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751806AbZHEXfU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 19:35:20 -0400
Received: from mail-yw0-f183.google.com ([209.85.211.183]:47569 "EHLO
	mail-yw0-f183.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751552AbZHEXfT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 19:35:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=ECSl/QM+VwL3kh6wSpFIDJjuNikLEljvw7Pijw86vRRPEGyJzgcIxALfYGio5Xuq0W
         9nfEqzjIYeZd6nS5Wqur94Zfa6WOjHAZ/rB8+bdyPN+B7rwDXE15U3JgM7xvR1U1aglL
         C/GtbhM74+KBjToQant3s6NZR+QCVthpld6vk=
Message-ID: <4A7A1734.5030202@gmail.com>
Date: Wed, 05 Aug 2009 17:35:16 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Gene Heskett <gene.heskett@verizon.net>
CC: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Strange wireless card?
References: <200908042306.36043.gene.heskett@verizon.net>
In-Reply-To: <200908042306.36043.gene.heskett@verizon.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/04/2009 09:06 PM, Gene Heskett wrote:
> Greetings;
>
> Can anyone tell me if this pci wireless card is supported, or what its
> status is?
>
>  From lspci -v:
> 01:06.0 Ethernet controller: Marvell Technology Group Ltd. 88w8335 [Libertas] 802.11b/g Wireless (rev 03)
>          Subsystem: Netgear WG311v3 802.11g Wireless PCI Adapter
>
> I have built a 2.6.31-rc5 kernel with the Marvel stuffs all enabled, but
> even a modprobe mwl8k, while apparently loading the driver, doesn't create
> any wireless devices in /dev.

they don't show up in /dev - tried iwconfig?
