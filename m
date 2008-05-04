Return-Path: <linux-kernel-owner+w=401wt.eu-S1756742AbYEDVCi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756742AbYEDVCi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2008 17:02:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752591AbYEDVC3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 May 2008 17:02:29 -0400
Received: from rv-out-0506.google.com ([209.85.198.232]:46379 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751231AbYEDVC2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2008 17:02:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Kge/ze5/Gkhoc0xKtvCAdcNeGLgfsUix713rmvav4OWch849OnZ3iObxKJ2Z/e6nb3EsZ9joWl3lyBY+4+lJSUDjTEvxjgjzSEKLhTUNSGVH+PAL7HLkZmq/fnGLSnLg+fJ+Dc3E67gpxhbIYRfLojl4/jzaKwJF7t1REf0rYw8=
Message-ID: <c4e36d110805041402o4e189aabm912ca0fed5acf1ed@mail.gmail.com>
Date: Sun, 4 May 2008 23:02:24 +0200
From: "Zdenek Kabelac" <zdenek.kabelac@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: Suspend to memory is freezing my machine
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <200805041240.52988.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <c4e36d110805040037u1b98c027x46dc17bf6be5da5b@mail.gmail.com>
	 <200805041240.52988.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/5/4, Rafael J. Wysocki <rjw@sisk.pl>:
> On Sunday, 4 of May 2008, Zdenek Kabelac wrote:
>  > Hello
>
>  Hi,
>
>
>  > With recent 2.6.25 & 2.6.26-rc1 git (around 1 week) I get occasionally
>  > complete freeze of my T61 during suspend. (dual core, 2GB).
>
>
> How reproducible is this?
>
>

Unfortunately not at my wish - usually in the least expected moment.
(Actually I've once even put notebook into the bag without checking
its sleeping :(
so it has got some hot inside :)  - from that time I has to keep an eye on this

>  > I'm running kernel with no_console_suspend - but all I can see is
>  > blinking cursor on an empty screen - thus even when I run kernel with
>  > most debug options turned on, I can't pass more details so far.  I run
>  > suspend with with SD card in - so maybe some update in the MMC driver
>  > might be responsible for this ?
>  >
>  > Also - I think that option no_console_suspend doens't work correctly -
>  > as many times with suspend I do not see any log message on my console
>  > screen. However sometimes the log is shown.
>
>
> It would be helpful if you could verify if:
>
>  (1) The problem occurs without no_console_suspend.

Yes - this has no influence - happens with & without

>  (2) The problem occurs without the SD card.

Will keep an eye on this - I usually keep SD card in.

Zdenek
