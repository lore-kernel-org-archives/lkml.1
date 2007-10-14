Return-Path: <linux-kernel-owner+w=401wt.eu-S1760060AbXJNW2j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760060AbXJNW2j (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2007 18:28:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763441AbXJNW22
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Oct 2007 18:28:28 -0400
Received: from lucidpixels.com ([75.144.35.66]:34744 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763733AbXJNW22 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2007 18:28:28 -0400
Date: Sun, 14 Oct 2007 18:28:26 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
X-X-Sender: jpiszcz@p34.internal.lan
To: Jan Engelhardt <jengelh@computergmbh.de>
cc: Al Viro <viro@ftp.linux.org.uk>, linux-kernel@vger.kernel.org,
       apiszcz@solarrain.com
Subject: Re: In response to kernel compression e-mail a few months ago.
In-Reply-To: <Pine.LNX.4.64.0710142348180.22801@fbirervta.pbzchgretzou.qr>
Message-ID: <Pine.LNX.4.64.0710141827210.16884@p34.internal.lan>
References: <Pine.LNX.4.64.0710141533080.3935@p34.internal.lan>
 <Pine.LNX.4.64.0710142144340.22801@fbirervta.pbzchgretzou.qr>
 <20071014205008.GZ8181@ftp.linux.org.uk> <Pine.LNX.4.64.0710141650500.12466@p34.internal.lan>
 <Pine.LNX.4.64.0710142348180.22801@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 14 Oct 2007, Jan Engelhardt wrote:

>
> On Oct 14 2007 16:58, Justin Piszcz wrote:
>>
>> compress:
>>  PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
>> 10544 war       20   0  700m 681m 1632 S  141 20.7   1:41.46 7z
>
> Just how you can utilize a CPU to 141% remains a mystery..
> [ to be noted this is sqrt(2)*100 ]
>

It uses 2 cores (multi-thread/multi-core), I believe the author of 7z (I 
asked him about this before) said the compression algorithm can use 
1.8-2.2 cpus.

Justin.
