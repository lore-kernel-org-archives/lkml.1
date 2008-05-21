Return-Path: <linux-kernel-owner+w=401wt.eu-S936333AbYEUV1y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936333AbYEUV1y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 17:27:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755937AbYEUV1p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 17:27:45 -0400
Received: from wa-out-1112.google.com ([209.85.146.179]:51953 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755741AbYEUV1p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 17:27:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=TFQ+j5zvr+T2HliOSxq7jcQyAy0nG9ek0C3VVxqSFEkMslQ81FkT0F2mR59LDKgmKGORD2TeY0AGV6KeCtrq2DirmLOfNzca20y58j33OUmU56vfJgfCfcbMMZLdLaq84uFMFj/CXS23l6mk/GHqs2pYYndMf2eK4tF4MQRBvMU=
Message-ID: <82fa9e310805211427q1bf92023nb37b7abbcb8fa4e6@mail.gmail.com>
Date: Wed, 21 May 2008 14:27:44 -0700
From: mark <markkicks@gmail.com>
To: "Jesper Juhl" <jesper.juhl@gmail.com>
Subject: Re: fork: Resource temporarily unavailable / cant start new threads
Cc: "Randy Dunlap" <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org
In-Reply-To: <9a8748490805211415x4f81fb71i7a04ff8d2c42d1b9@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <82fa9e310805201126q45e869bdub74a947068fe612a@mail.gmail.com>
	 <20080521132845.72db5748.randy.dunlap@oracle.com>
	 <82fa9e310805211339o3090e0d0le8503051d3e0aa38@mail.gmail.com>
	 <48348AFA.1070900@oracle.com>
	 <82fa9e310805211408o65b49923jd9bf4a6c89b97c30@mail.gmail.com>
	 <9a8748490805211415x4f81fb71i7a04ff8d2c42d1b9@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 21, 2008 at 2:15 PM, Jesper Juhl <jesper.juhl@gmail.com> wrote:
> 2008/5/21 mark <markkicks@gmail.com>:
> <snip>
>>>> my webserver is now throwing this error:
>>>>
>>>> setuid(500) failed (11: Resource temporarily unavailable)
>>>
>>> That's all of the useful information??
>>
>> Yes. i get this error  when i restart the web server. if i kill all
>> other apps, and then start it again it starts fine.
>>
>> this is the complete error message,
>> 2008/05/21 08:02:19 [emerg] 30558#0: setuid(500) failed (11: Resource
>> temporarily unavailable)
>> 2008/05/21 08:02:19 [alert] 30557#0: worker process 30558 exited with
>> fatal code 2 and can not be respawn
>
> What about if you run 'dmesg'? are there any clues in that output?
> any kernel stack traces? error messages? warnings? anything out of the
> ordinary?
No.
There is no new message added after kernel boot messages
