Return-Path: <linux-kernel-owner+w=401wt.eu-S1756577AbZKURla@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756577AbZKURla (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Nov 2009 12:41:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756546AbZKURla
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Nov 2009 12:41:30 -0500
Received: from mail-yw0-f182.google.com ([209.85.211.182]:49630 "EHLO
	mail-yw0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756018AbZKURl3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Nov 2009 12:41:29 -0500
X-Greylist: delayed 364 seconds by postgrey-1.27 at vger.kernel.org; Sat, 21 Nov 2009 12:41:29 EST
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=cKTnV51Vg/iA+oiXYSV7KgKLo2f1cEN0hdv4G5Fb+ecFEZZ8Q+pMoyarpIJYx+OM5D
         HGru/vaiY7agQg72zg0kOYRe7Ceu72qjDkQXTvHpHrXgkv1qbBCCIYdqMwKusAmRPMi3
         R9fFQZeOoZ3E4mDFUGjVsxtl8cx6WV4OhhBHw=
Message-ID: <4B0824E1.7030405@gmail.com>
Date: Sat, 21 Nov 2009 11:35:29 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Albretch Mueller <lbrtchx@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Hibernating under Linux ...
References: <12a0d5b0-698a-40c5-8097-58a145acda12@x31g2000yqx.googlegroups.com>
In-Reply-To: <12a0d5b0-698a-40c5-8097-58a145acda12@x31g2000yqx.googlegroups.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/21/2009 06:49 AM, Albretch Mueller wrote:
>
> One of the few things I think Windows does well (well, definitely
> better than "us") is hibernating. You can actually notice how the hard
> drives don't seem to be powered and even the fans stop spipping
>
> I have tried hibernating under both, knoppix 6.2 and Ubuntu 9.10 and
> none of them get it right. Is there any Linux distro that does?
>
> Why is that?

You didn't give any details on your hardware, or on exactly what's 
happening on your system. However, normally "hibernate" should be a full 
power-down.
