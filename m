Return-Path: <linux-kernel-owner+w=401wt.eu-S1763027AbYJJVUf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763027AbYJJVUf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 17:20:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761001AbYJJVUD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 17:20:03 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:35669 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760256AbYJJVUA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 17:20:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:user-agent:mime-version:to:cc:subject:references
         :in-reply-to:content-type:content-transfer-encoding:from;
        b=GEFawNmZUCLB7ZEXXWkXM/f+l3efX4SKBc3COCP/PBskqsY6eSMJ8n7iz5AvINtfa4
         JjiNHYV0HcisD5CPIfa7DiO8aSXZjiMf2OfxMrfTEr2YjeNZiJSFp6Uf0hMda4A2PWNl
         gkCF8U5Kp9INCkm+ns5vV85jF6+q+I9R2DJOc=
Message-ID: <48EFC6FB.7060408@gmail.com>
Date: Fri, 10 Oct 2008 22:19:55 +0100
User-Agent: Thunderbird 2.0.0.16 (X11/20080810)
MIME-Version: 1.0
To: Andrey Borzenkov <arvidjaar@newmail.ru>
CC: orinoco-devel@lists.sourceforge.net, linux-wireless@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: rc9 + orinoco WPA patchset: BUG: scheduling while atomic loading
 firmware with PCMCIA adapter
References: <200810091722.56812.arvidjaar@newmail.ru> <200810102114.55663.arvidjaar@newmail.ru> <48EF8E01.2060709@gmail.com> <200810102126.32246.arvidjaar@newmail.ru>
In-Reply-To: <200810102126.32246.arvidjaar@newmail.ru>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
From: Dave <kilroyd@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrey Borzenkov wrote:
> On Friday 10 October 2008, Dave wrote:
>> Andrey Borzenkov wrote:
>>> On Friday 10 October 2008, Dave wrote:
>>>> You're right. pda_size is supposed to be the maximum size of the PDA (in bytes) that we expect with the firmware. It should be set to 0x200.
>>>>
>>> Do you want me to send a patch?
>> Could you fix it as part of the patch you submitted?
>>
> 
> Attached. As other entries use decimal I thought it is more logical
> to use 512 as well.

ACK.

