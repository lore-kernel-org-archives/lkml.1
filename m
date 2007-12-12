Return-Path: <linux-kernel-owner+w=401wt.eu-S1758670AbXLLIsz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758670AbXLLIsz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 03:48:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758116AbXLLIsk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 03:48:40 -0500
Received: from an-out-0708.google.com ([209.85.132.244]:29388 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757978AbXLLIsj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 03:48:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=KjC2uTOFtjrwk2DppLYt3hp8PzN3eUBMQj+ts1jN7flOI5foECyGphzh3tO0B/oYbs7WBq84MSQC5b4q984cx4nP1mjQbuaxMrgLJoU8CWwSf+W+f9ZJA7lgHRnyrgEIcZ9cBMKe9/HRTqf996UZNKDn8bStUgKoFPQb7nMDazc=
Message-ID: <475FA060.6070004@gmail.com>
Date: Wed, 12 Dec 2007 09:48:32 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Rene Herman <rene.herman@gmail.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>, dpreed@reed.com,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, pavel@ucw.cz, andi@firstfloor.org,
       rol@as2917.net, Krzysztof Halasa <khc@pm.waw.pl>, david@davidnewall.com,
       hpa@zytor.com, john@stoffel.org, linux-os@analogic.com
Subject: Re: [RFT] Port 0x80 I/O speed
References: <475F1DC6.5090403@keyaccess.nl>
In-Reply-To: <475F1DC6.5090403@keyaccess.nl>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/12/2007 12:31 AM, Rene Herman wrote:
> Good day.
> 
> Would some people on x86 (both 32 and 64) be kind enough to compile and
> run the attached program? This is about testing how long I/O port access

model name      : Intel(R) Core(TM)2 Duo CPU     E6850  @ 3.00GHz

cycles: out 6490, in 3135
cycles: out 6484, in 3126
cycles: out 6511, in 3128
cycles: out 6500, in 3135
cycles: out 6492, in 3154
cycles: out 6506, in 3136
cycles: out 6516, in 3144
cycles: out 6489, in 3140
cycles: out 6492, in 3129
cycles: out 6507, in 3130

