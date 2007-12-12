Return-Path: <linux-kernel-owner+w=401wt.eu-S1760235AbXLLTVO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760235AbXLLTVO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 14:21:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759011AbXLLTUu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 14:20:50 -0500
Received: from nf-out-0910.google.com ([64.233.182.186]:62493 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758236AbXLLTUt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 14:20:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding:from;
        b=SLggS8LodCBgUGt0OW5Zy20UvO91ZwrBvgcapkHoiQ0bHlzS1/S5p1O5cJf2IcAyiwO6XqDvEweaozD4lCl/KE0HVwyjO2L+P5hWUvLY2NoyWYfBVh3YnJXXS/DY2TblAqQQV64TflTy88Cl9yv27T7nAvd9k2Cy8GtuSRwCIqE=
Message-ID: <47603437.905@keyaccess.nl>
Date: Wed, 12 Dec 2007 20:19:19 +0100
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Jiri Slaby <jirislaby@gmail.com>, Rene Herman <rene.herman@gmail.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>, dpreed@reed.com,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, pavel@ucw.cz, andi@firstfloor.org,
       rol@as2917.net, Krzysztof Halasa <khc@pm.waw.pl>, david@davidnewall.com,
       john@stoffel.org, linux-os@analogic.com
Subject: Re: [RFT] Port 0x80 I/O speed
References: <475F1DC6.5090403@keyaccess.nl> <475FA060.6070004@gmail.com> <4af2d03a0712120325n50d057baq7ec440c5e57fda39@mail.gmail.com> <47602BF2.9030602@zytor.com>
In-Reply-To: <47602BF2.9030602@zytor.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 8bit
From: Rene Herman <rene.herman@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12-12-07 19:44, H. Peter Anvin wrote:

>> model name      : Intel(R) Xeon(R) CPU           E5335  @ 2.00GHz 
>> cycles: out 3217, in 1898
> 
> 1.6 µs, on the high end....
> 
>> model name      : Dual Core AMD Opteron(tm) Processor 275
>> cycles: out 5508, in 5524
> 
> Definitely an outlier; 2.5 µs here.

Jah, I don't trust that one. Just posted the complete results:

http://lkml.org/lkml/2007/12/12/309

Rene.
