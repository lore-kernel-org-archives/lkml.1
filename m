Return-Path: <linux-kernel-owner+w=401wt.eu-S1755059AbXJBKnV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755059AbXJBKnV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 06:43:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752637AbXJBKnL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 06:43:11 -0400
Received: from wx-out-0506.google.com ([66.249.82.228]:46513 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752205AbXJBKnI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 06:43:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:reply-to:organization:user-agent:x-accept-language:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=HGE0y6kSa4d/Lz/zsl8B3x36FIGd4mDq0ZAFXKKkZcMAJZ6nPQD/Tc/rasYyF6BNT+NDuLMo8iwn+G1WzxCnDczML2SCxs0psZPQQUj1JFar3NRVZn4gGWOwpLCNYcApi53qRPae5v97E6UpRv3z+ZbEfEDjJNyfJ4FRT0fN9pg=
Message-ID: <470220FE.2090506@gmail.com>
Date: Tue, 02 Oct 2007 07:44:14 -0300
From: Hernan G Solari <hgsolari@gmail.com>
Reply-To: hgsolari@gmail.com, solari@df.uba.ar
Organization: Universidad de Buenos Aires
User-Agent: Debian Thunderbird 1.0.2 (X11/20060927)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Tejun Heo <htejun@gmail.com>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
       IDE/ATA development list <linux-ide@vger.kernel.org>,
       linux acpi <linux-acpi@vger.kernel.org>
Subject: Re: Serial ATA does not find partitions (Hitachi HD, new? ATI controller)
 where old SATA works
References: <46FC4384.7080607@df.uba.ar> <46FCCD57.2020507@gmail.com> <47014740.5080002@df.uba.ar> <4701EA71.2000609@gmail.com>
In-Reply-To: <4701EA71.2000609@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


>>   netconsole, pritty nice debunging system... but (yes, there is always
>>a but) it does not get to run.
>>   the method was well implemented, adding the acpi=off it sends the
>>information to the receiving machine (I can even see passing a
>>netconsole probing message in the machine under testing), but without
>>turning off acpi it does not reach the point of loading and,
>>consequently, it does not send a byte to the receiving machine.
>>
>>Hence, result: empty output.
>>    
>>
>
>Hmmm.. Are netconsole support and network driver built into the kernel?
>
>  
>
yes, they are
                      Hernan

-- 
Hernán Gustavo Solari, solari@df.uba.ar, http://www.df.uba.ar/~solari

