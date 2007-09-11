Return-Path: <linux-kernel-owner+w=401wt.eu-S1763384AbXIKKJR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763384AbXIKKJR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 06:09:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757321AbXIKKJE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 06:09:04 -0400
Received: from smtpauth02.prod.mesa1.secureserver.net ([64.202.165.182]:58726
	"HELO smtpauth02.prod.mesa1.secureserver.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753283AbXIKKJD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 06:09:03 -0400
Message-ID: <46E6B674.3030105@gmail.com>
Date: Tue, 11 Sep 2007 21:08:28 +0530
From: mkrameshid <mkrameshid@gmail.com>
User-Agent: Thunderbird 1.5.0.7 (X11/20061008)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: linux-kernel@vger.kernel.org
Subject: Re: Calling PnP bios routines like get device node from x86_84 arch
References: <12594726.post@talk.nabble.com>	<20070910173344.4bd2ae9e@the-village.bc.nu>	<46E675E6.1040105@gmail.com> <20070911105108.6d68a347@the-village.bc.nu>
In-Reply-To: <20070911105108.6d68a347@the-village.bc.nu>
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for the reply. I will try ACPI and let you know the result.

-mkr
Alan Cox wrote:
>> Actually I want to call the BIOS run time functions as per the 
>> PNPBIOSSpecification-v1.0a (attached).
>>     
>
> We use ACPI for x86_64, which means you need to use the ACPI methods not
> the PnPBIOS ones. PnPBIOS isn't valid when ACPI is in use.
>
> Alan
>
>   

