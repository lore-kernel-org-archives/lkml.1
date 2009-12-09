Return-Path: <linux-kernel-owner+w=401wt.eu-S1755040AbZLIVJz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755040AbZLIVJz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 16:09:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753955AbZLIVJt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 16:09:49 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:34591 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750823AbZLIVJs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 16:09:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=jgtQKCI691/sTZ45g0tRrKrSFZkwrf0i+AvJ6dK/GOITgBP/vmpV54iNuWwgTlLBUv
         esVWzAx74Cee8gCbHipqz+yssosvsgBEww5HNTtqMyEYAsFsrkmDWUsuhXVXWz6LKNM8
         5lisQTam8lcXE3XhUanWDmmuGqMXy0yuat1TA=
MIME-Version: 1.0
In-Reply-To: <4B1FC5A4.9030300@bfs.de>
References: <20091209143540.GA9620@vacuum.larces.uece.br>
	 <20091209145554.GQ6070@fi.muni.cz> <4B1FC5A4.9030300@bfs.de>
Date: Wed, 9 Dec 2009 18:09:54 -0300
Message-ID: <235c15c10912091309q6c20b417y3f80dbac0be2a073@mail.gmail.com>
Subject: Re: [PATCH] Coding style correction on some drivers that use Generic 
	HDLC
From: Rudy Matela <rudy.matela@gmail.com>
To: wharms@bfs.de
Cc: Jan Yenya Kasprzak <kas@fi.muni.cz>, Krzysztof Halasa <khc@pm.waw.pl>,
       trivial@kernel.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 9, 2009 at 12:43, walter harms <wharms@bfs.de> wrote:
>
>
> Jan Yenya Kasprzak schrieb:
>> Rudy Matela wrote:
>> : Added a space separating some if/switch/while keywords from the following
>> : parenthesis to conform to the CodingStyle.
>>
>>       Hello,
>>
>>       I am not sure whether it is necessary to fix formating mistakes in
>> a driver which is in deep freeze and the hardware is not produced anymore,
>> but whatever.
>>
>
> It is ok until the driver is removed, if this "issue" is not fixed it will
> trigger any check-coding-style and generate new patches. Since it involves
> no code changes it is harmless.
>
> re,
>  wh
>
>

Hello to all,

  Sould I keep sending coding style corrections to the Linux Kernel?
I'm trying to help, but if i'm just being annoying, please tell me and
I can try to contribute in a better way.  :-)

  Regards,
  Rudy
