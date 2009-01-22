Return-Path: <linux-kernel-owner+w=401wt.eu-S1756897AbZAVNI4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756897AbZAVNI4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 08:08:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753232AbZAVNIp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 08:08:45 -0500
Received: from yx-out-2324.google.com ([74.125.44.30]:10797 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752859AbZAVNIp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 08:08:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=xH3LxXHJ57N0DmEmNI3wq71jDbMmUgXTA361uZqlYVLe0z7s/yML8SJvDlKqc9Ok7o
         WuVjErG8yZPIfFvNxhZrJBQQzbfVWI+bto6yTv4Mu7yct8I0veyD3MQYxb2bpXti82xr
         UWMonsZhIvoBK+MCOdM6h1FA3NSPLBX04NoJI=
MIME-Version: 1.0
In-Reply-To: <49784F79.1070905@hiramoto.org>
References: <b0438a630901212342o543ed522p60376f764b6248b5@mail.gmail.com>
	 <49784F79.1070905@hiramoto.org>
Date: Thu, 22 Jan 2009 14:08:43 +0100
Message-ID: <b0438a630901220508y479a2ff5o9cfa228bcafe0b2b@mail.gmail.com>
Subject: Re: IXP4XX queues
From: =?ISO-8859-1?Q?Miguel_=C1ngel_=C1lvarez?= <gotzoncabanes@gmail.com>
To: Karl Hiramoto <karl@hiramoto.org>
Cc: Krzysztof Halasa <khc@pm.waw.pl>,
       linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Thu, Jan 22, 2009 at 11:50 AM, Karl Hiramoto <karl@hiramoto.org> wrote:
> Miguel Ángel Álvarez wrote:
>> Hi
>>
>> Last December we talked about 64 queues and IXP4XX. Karl has a patch
>> for them, and although I think it could be better to splitt it into
>> two different ones ("plain 64 queue expansion" for which I proposed a
>> modified patch based on Karl's, and "debugging and other things"), I
>> prefer Karl's to none.
>>
>> What do you think of this? Which should be the best way to include it
>> in the main stream kernel?
>>
>> Thanks
>>
>> Miguel Ángel
>>
>>
> The patch needs minor  rework so it  applies cleanly against 2.6.29-rc2
> at the moment i don't have time to do this and test it.
>
I do not have much problem in doing that rework myself. However I need
help in making its way into the kernel, because I have not good
experiences in that.

Miguel Ángel
