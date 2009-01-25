Return-Path: <linux-kernel-owner+w=401wt.eu-S1756302AbZAYLT0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756302AbZAYLT0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2009 06:19:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752247AbZAYLTS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Jan 2009 06:19:18 -0500
Received: from rv-out-0506.google.com ([209.85.198.232]:33076 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752138AbZAYLTR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2009 06:19:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=OG1YXZyUTiCkq1fzV4kh0EHfUT0CygXBhRb785uVbqY6HzDU0VKRfjr7GVLHkbAwWK
         uendFon6Xx1lPwrwu/hMlrq4RYbgEOwQmP+1IewCr0Xj+s57axA9XTiKsMmEIoF4Q9Lp
         lW8FU9ZEGmdEb5hxP6cz8ziKArxFSXj/N7NBw=
MIME-Version: 1.0
In-Reply-To: <1232880058.4303.46.camel@localhost.localdomain>
References: <93655eb70901242057n7e0e3757p467f91352cbae932@mail.gmail.com>
	 <1232866165.3195.1.camel@localhost.localdomain>
	 <93655eb70901250037k79286904oc859118946155766@mail.gmail.com>
	 <1232879436.4303.40.camel@localhost.localdomain>
	 <1232880058.4303.46.camel@localhost.localdomain>
Date: Sun, 25 Jan 2009 16:49:16 +0530
Message-ID: <93655eb70901250319m334665bew9b5f6738ba6282a7@mail.gmail.com>
Subject: Re: building custom module on 2.6.28 fails
From: Satish Eerpini <eerpini@gmail.com>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Sam Ravnborg <sam@ravnborg.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> It seems you run "make clean" or "make distclean" in your kernel sources
>>
>> run "make prepare" in your kernel sources then you will not get this
>> error.
>

I ran make clean and then make prepare but it gives an error saying
"no such file or directory : modpost ", ....
Then i ran make( in the kernel source tree) , and terminated it after
a few files were compiled and then again tried to compile my module,
this time it worked without any errors, ....... any particular reason
for this ??

Thanks
Satish
-- 
http://satish.playdrupal.com
