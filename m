Return-Path: <linux-kernel-owner+w=401wt.eu-S1752678AbZAaGpO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752678AbZAaGpO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Jan 2009 01:45:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751315AbZAaGo7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Jan 2009 01:44:59 -0500
Received: from rv-out-0506.google.com ([209.85.198.231]:2488 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751290AbZAaGo6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Jan 2009 01:44:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=av+LJuGEPTbjaV3zMq8IodWmkKPtXFP5QDOvDpuWlMbLLyMohkSjQ0OldffvMylhlc
         aiSIqgKbhFHxPCqi/KhAH0KXUzcL/dcIwYzqjUTnJ9dxBYuO94kqtf4c5ZdD5vnTqV3U
         jlS80w0MbQsJjR5vXbPgSzTg7QVPI90a1s9aI=
Message-ID: <4983F365.40701@gmail.com>
Date: Fri, 30 Jan 2009 22:44:53 -0800
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Soeren Sonnenburg <kernel@nn7.de>
CC: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.29-rc3+git macbook pro1,1 garbled display on resume
References: <1233348609.3707.6.camel@localhost>
In-Reply-To: <1233348609.3707.6.camel@localhost>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Soeren Sonnenburg wrote:
> Hi,
>
> the macbook pro suspends just fine, but even though the machine returns
> to X I see on resume some random garbled output but can still move the
> mouse cursor (which is OK!) and using the keyboard successfully adjust
> the brightness of the display.
>
> However I cannot switch to the console (via ctrl+alt+f1) nor does ctrl
> +alt+backspace do anything....
>
> This is on debian sid with the latest xorg radeon driver from
> experimental, i.e. ii  xserver-xorg-video-radeon
> 1:6.9.0.91-1.
>
> Any ideas?
> Soeren
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
>   
Same here with jaunty i.g.
one week it worked then the next it didn't.
maybe disabling hotplug with xorg.conf
might make the keys work.

regards;

Justin P. Mattock
