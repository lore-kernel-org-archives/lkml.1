Return-Path: <linux-kernel-owner+w=401wt.eu-S934425AbZDINBu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934425AbZDINBu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 09:01:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934341AbZDINBB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 09:01:01 -0400
Received: from mail-ew0-f165.google.com ([209.85.219.165]:40445 "EHLO
	mail-ew0-f165.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933137AbZDINA7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 09:00:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=MaGwnmx82820xgZkirN34+IApNXG/ZlmF8mVpqN2c0gH69oaAmHVsuhd5BzQ9LKpLA
         7GXRm150bVXsy9UJQE37NiWYMbZSlg+5UWh+0YC5u/JFwWdZ5GoDSdrQjC9U2yjDDgvc
         I/gihz8E81HJaX7JcUs5SE1gcktG8yjnB/sFk=
MIME-Version: 1.0
In-Reply-To: <19f34abd0904081015r5549da00w97593be16373bb8c@mail.gmail.com>
References: <a4423d670904081012j30ad104etefeee0c8c682aca9@mail.gmail.com>
	 <19f34abd0904081015r5549da00w97593be16373bb8c@mail.gmail.com>
Date: Thu, 9 Apr 2009 17:00:57 +0400
Message-ID: <a4423d670904090600w7286ec0elda3c608b740281ea@mail.gmail.com>
Subject: Re: 2.6.30-rc1 cannot boot: scsi/async
From: Alexander Beregalov <a.beregalov@gmail.com>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       linux-scsi@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/4/8 Vegard Nossum <vegard.nossum@gmail.com>:
> 2009/4/8 Alexander Beregalov <a.beregalov@gmail.com>:
>> Hi
>>
>> It is 2*2 SMP system, x86_64.
>>
>> INFO: task async/0:1073 blocked for more than 120 seconds.
>
>
> Hi,
>
> I just proposed a patch to fix this:
>
> http://marc.info/?l=linux-kernel&m=123920746830420&w=2
>
> Don't know if it's correct or whether it actually fixes the problem,
> but you are welcome to try it :-)

It works for me as well. Thanks.
