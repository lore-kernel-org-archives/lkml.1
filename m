Return-Path: <linux-kernel-owner+w=401wt.eu-S1752039AbZBNJUw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752039AbZBNJUw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Feb 2009 04:20:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750832AbZBNJUg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Feb 2009 04:20:36 -0500
Received: from wa-out-1112.google.com ([209.85.146.179]:20042 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750792AbZBNJUe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Feb 2009 04:20:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Tq7NF3puW0cGCdscaP09kwKzLfpE4bMrjzde888VA4f7xw+uOS0XQpbO2lq37xYXrW
         NunxYcAJzlKRS8U/lB0ZCboKm4LZddVEcgGL+Mi93PuBwXREH1Ub8+06aFFQAdFZ5jht
         FFjQJOGJW5/BOojmdTJgQl0zpGmMcoUQvgduI=
MIME-Version: 1.0
In-Reply-To: <200902140917.38313.philippe.grenard@laposte.net>
References: <200902131944.56634.philippe.grenard@laposte.net>
	 <200902132056.20097.philippe.grenard@laposte.net>
	 <18837.56478.10536.6978@stoffel.org>
	 <200902140917.38313.philippe.grenard@laposte.net>
Date: Sat, 14 Feb 2009 14:50:33 +0530
Message-ID: <3f9a31f40902140120v6e8db503m6bf5c2bad39c2544@mail.gmail.com>
Subject: Re: PROBLEM: cannot get stable system since 2.6.28 kernel
From: Jaswinder Singh Rajput <jaswinderlinux@gmail.com>
To: Philippe Grenard <philippe.grenard@laposte.net>
Cc: linux-kernel@vger.kernel.org, John Stoffel <john@stoffel.org>,
       Len Brown <lenb@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 14, 2009 at 1:47 PM, Philippe Grenard
<philippe.grenard@laposte.net> wrote:
> On Friday 13 February 2009 21:48:30 John Stoffel wrote:
>>
>> Here's your problem most probably.  The nVidia graphics module.
>> Remove that and re-try your system.  Basically, we can't help you when
>> you use a vendor's binary module.
>>
>> John
>
> Well, it does not change anything to my problem...
> Moreover, I don't understand why this would work with 2.6.27.10 but not with
> 2.6.29-rc4 ....

May be nvidia graphics module was written based on some kernel which
is more closer to 2.6.27.10 as compare to 2.6.29-rc4.

Another thing which John is pointing configure your bios to use
standard inbuild garphics card OR remove nvidia module and check
whether it solves your problem or not.

--
JSR
