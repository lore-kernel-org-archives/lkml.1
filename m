Return-Path: <linux-kernel-owner+w=401wt.eu-S1761628AbZEHTuZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761628AbZEHTuZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 15:50:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755031AbZEHTuG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 15:50:06 -0400
Received: from mail-bw0-f174.google.com ([209.85.218.174]:61289 "EHLO
	mail-bw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754880AbZEHTuE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 15:50:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=CeClb5GG1WD3k2hpcuzMoearyOEwjBf7cUTnWr/aeOFStDLhJClhZrWi37aCPMgiLm
         O+k3StFUy75nfD+7qHPa/qTDTkLJuvfqb65Qw/NImGSJfYyh3d8fKLmfP0QoYWb/kEma
         0fRnmZgiQb0u9791wqKUAIJrtXfq/jPlTPTow=
MIME-Version: 1.0
In-Reply-To: <4A048AF4.1080205@garzik.org>
References: <c5bd819b0905081228m4ee6472bhc3968b178f038b9c@mail.gmail.com>
	 <4A048AF4.1080205@garzik.org>
Date: Fri, 8 May 2009 21:50:04 +0200
Message-ID: <c5bd819b0905081250k2095beb6r1aae22fcd82ac468@mail.gmail.com>
Subject: Re: Linux and LLVM
From: Grozdan <neutrino8@gmail.com>
To: Jeff Garzik <jeff@garzik.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/5/8 Jeff Garzik <jeff@garzik.org>:
> Grozdan wrote:
>>
>> Hi,
>>
>> First, I'd like to say that I'm not interested in any holy wars,
>> trolling, ego-boosters, or whatever, and basically want to ask a
>> simple question and get the views of the Linux developers on it, at
>> least from those who are interested in answering it or have time to do
>> so as I know that most kernel devs are very busy :)
>>
>> Recently, FreeBSD has reported that it's slowly switching from GCC to
>> LLVM/CLANG for compilers. What are the thoughts of the Linux kernel
>> devs about this and do they things that it's a good idea to go in the
>> same direction as FreeBSD (switching over to LLVM)?
>
> It is highly unlikely we will switch compilers away from gcc -- we have
> enough problems just supporting multiple gcc versions.
>
> That said, you could join the effort to get LLVM to compile under the
> kernel.  Here is a meta-bug for that:
> http://llvm.org/bugs/show_bug.cgi?id=4068
>
> It is a moot question until LLVM can actually build a bootable kernel :)

Thanks for the quick answer! I was not aware that currently there's
lots of work until CLANG can compile a bootable Linux kernel. Thanks
for the link too. I'll dig through it

>
> Regards,
>
>        Jeff
>
>
>
>
