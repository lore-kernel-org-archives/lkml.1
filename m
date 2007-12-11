Return-Path: <linux-kernel-owner+w=401wt.eu-S1757978AbXLKXqU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757978AbXLKXqU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 18:46:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752671AbXLKXqM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 18:46:12 -0500
Received: from nf-out-0910.google.com ([64.233.182.190]:26033 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751874AbXLKXqK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 18:46:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding:from;
        b=VrVyCKzqH0UYcAUPlN4yqxZUKEh29tY9P/sGIbEz7MJx24UzOb/9vkemkfgpwQLCEw7OKaJM1+etSj6DOmRcSC/+EuYqGm4LoL3y87Q1DQkN8u9wWlJFc3pQI9DHqAOIXckIQgImiFgSpaD0QbHbvIWldnQFl9+azg+/uABaSso=
Message-ID: <475F20EA.5050803@keyaccess.nl>
Date: Wed, 12 Dec 2007 00:44:42 +0100
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Maxim Levitsky <maximlevitsky@gmail.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>, dpreed@reed.com,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, pavel@ucw.cz, andi@firstfloor.org,
       rol@as2917.net, Krzysztof Halasa <khc@pm.waw.pl>, david@davidnewall.com,
       hpa@zytor.com, john@stoffel.org, linux-os@analogic.com
Subject: Re: [RFT] Port 0x80 I/O speed
References: <475F1DC6.5090403@keyaccess.nl> <200712120140.34697.maximlevitsky@gmail.com>
In-Reply-To: <200712120140.34697.maximlevitsky@gmail.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
From: Rene Herman <rene.herman@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12-12-07 00:40, Maxim Levitsky wrote:

> maxim@MAIN:~/tmp$ sudo ./port800
> cycles: out 1767, in 1147
> maxim@MAIN:~/tmp$ sudo ./port800
> cycles: out 1774, in 1148
> maxim@MAIN:~/tmp$ sudo ./port800
> cycles: out 1769, in 1150
> maxim@MAIN:~/tmp$ sudo ./port800
> cycles: out 1769, in 1150
> maxim@MAIN:~/tmp$ sudo ./port800
> cycles: out 1777, in 1150
> maxim@MAIN:~/tmp$ sudo ./port800
> cycles: out 1766, in 1149
> maxim@MAIN:~/tmp$ sudo ./port800
> cycles: out 1768, in 1148
> maxim@MAIN:~/tmp$ sudo ./port800
> cycles: out 1765, in 1147
> 
> 
> Core 2 Duo system (ICH8/Intel DG965RY motherboard)

1.8 Ghz?

Rene.

