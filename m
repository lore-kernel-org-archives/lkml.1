Return-Path: <linux-kernel-owner+w=401wt.eu-S1758802AbZA2PGh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758802AbZA2PGh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 10:06:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754004AbZA2PG2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 10:06:28 -0500
Received: from rv-out-0506.google.com ([209.85.198.230]:10240 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753854AbZA2PG1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 10:06:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=gdMQADt0Vh1FqU/Q0SRC32vkqU12B5x6nBxcDixI3WqTYdiaVbhodockU+/lHLFo4F
         jw6uzj/QK99vVVC2P7uy0mXKhH3z17xNeFrp3g+hwaiTtcLCiz4evStAEm9bVwaKPWWa
         zWazApog5nZ0YZ7+XP/RvWhosKHGRsgYkKi4k=
Message-ID: <4981C5F1.60706@gmail.com>
Date: Thu, 29 Jan 2009 07:06:25 -0800
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: linux-kernel@vger.kernel.org
Subject: Re: macbook pro radeon suspend issue
References: <49812E3B.6050106@gmail.com> <200901291536.37348.rjw@sisk.pl>
In-Reply-To: <200901291536.37348.rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> On Thursday 29 January 2009, Justin P. Mattock wrote:
>   
>> No sure if there is a bug report already or not.
>> For the macbook pro(ATI chipset) suspend is broken.
>> As for kernel version: latest git.
>> Last week(before LCA, and during the week, since being no merges.)
>> the system would wakeup, show a black screen and sit there. Now
>> after a couple of merges have been completed The system wakes up,
>> but instantly reboot's.
>>
>> I tried to supply any info(ohci1394_dma) when the wakeup occurs, but had 
>> no response
>> for some reason or another.
>> I can try and do a bisect, the only problem
>> I have though, is I never labeled good/bad commits(forgot how too);
>>
>> In any case If I'm in an urgent need, of having  to suspend
>> the system(not in anytime soon at the moment),
>> then Ill just revert kernels to one that I know works.     :^)
>>     
>
> Which is that?
>
> Rafael
>
>   
 From what I remember 2.6.27,
(whatever kernel I was using when, you had mentioned to me to
use s2ram with radeon);

regards;

Justin P. Mattock
