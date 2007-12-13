Return-Path: <linux-kernel-owner+w=401wt.eu-S1762038AbXLMPUG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762038AbXLMPUG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 10:20:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753873AbXLMPTz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 10:19:55 -0500
Received: from ug-out-1314.google.com ([66.249.92.170]:53699 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753036AbXLMPTy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 10:19:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=j7UqD36ZcMI2yqZuiPfhfuYMW1Sy/MtkYD7Qo/y6wJZs0jkatpJn0uwYt8m6fgdNhd6UeeFZFK3HZP/h+WSYC5mH1/C1JbvRRmaMPr5INxRub9xlLQV3D03Wak9YO2IjP08U/RA1zN1/PihCmEsfzOcUrNr2IGLJojDsAvisXz8=
Message-ID: <47614D99.7090505@gmail.com>
Date: Thu, 13 Dec 2007 16:19:53 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Rene Herman <rene.herman@gmail.com>
CC: "H. Peter Anvin" <hpa@zytor.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>, dpreed@reed.com,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, pavel@ucw.cz, andi@firstfloor.org,
       rol@as2917.net, Krzysztof Halasa <khc@pm.waw.pl>, david@davidnewall.com,
       john@stoffel.org, linux-os@analogic.com
Subject: Re: [RFT] Port 0x80 I/O speed
References: <475F1DC6.5090403@keyaccess.nl> <475FA060.6070004@gmail.com> <4af2d03a0712120325n50d057baq7ec440c5e57fda39@mail.gmail.com> <47602BF2.9030602@zytor.com> <47603437.905@keyaccess.nl>
In-Reply-To: <47603437.905@keyaccess.nl>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rene Herman napsal(a):
> On 12-12-07 19:44, H. Peter Anvin wrote:
> 
>>> model name      : Intel(R) Xeon(R) CPU           E5335  @ 2.00GHz
>>> cycles: out 3217, in 1898
>>
>> 1.6 µs, on the high end....
>>
>>> model name      : Dual Core AMD Opteron(tm) Processor 275
>>> cycles: out 5508, in 5524
>>
>> Definitely an outlier; 2.5 µs here.

Now, it's around
cycles: out 4763, in 5515

It's
cpu MHz         : 2205.209
