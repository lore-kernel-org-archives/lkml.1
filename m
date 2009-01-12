Return-Path: <linux-kernel-owner+w=401wt.eu-S1754138AbZALCOq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754138AbZALCOq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 21:14:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750851AbZALCOi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 21:14:38 -0500
Received: from web34408.mail.mud.yahoo.com ([66.163.178.157]:44887 "HELO
	web34408.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751174AbZALCOh convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 21:14:37 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.br;
  h=X-YMail-OSG:Received:X-Mailer:Date:From:Reply-To:Subject:To:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=a2ccVZTYrtHbZITSdKzL+x3QCXJjDtDE8ZPYMwkg9Y33Nfl5/HdG53tdVuHxEdG3+DcUsWVvHneQVJNvc84RDxB7cXXs+cesH7Br+pF76VmqeHA0MBMxhyR3N0XtzNReiDQRNtS1ZaH5LGRd81PEgKt1MW4GBbULNqnobNkqJ9w=;
X-YMail-OSG: aKUvGM0VM1nE.BGMEW40Yc5gYR1zTnwMjiJ2agABpvt6b.1iiv.Wu38VQQO9vQuMvc3q4ndfn3uSce4y9Z53a7jFn7_lUipXUJwwP3JTE85j_u9viFiYX0MEJ7Wg3TBJMsChCDLi8Li9jQqnm4EpEfSSFFT6PUPGanmKlZ2Nc1Y1EkeVKEF4UjSblVNomYtxOBuXZnCnrepwlRn2mqqGunqwQML4kHVegefo6cc-
X-Mailer: YahooMailWebService/0.7.260.1
Date: Sun, 11 Jan 2009 18:14:35 -0800 (PST)
From: Jose Luis Marchetti <joseluismarchetti@yahoo.com.br>
Reply-To: joseluismarchetti@yahoo.com.br
Subject: Re: MAC address runtime configuration in new driver (was Re: ...no subject)
To: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
In-Reply-To: <496A0C4E.5040502@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Message-ID: <658601.69208.qm@web34408.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> http://kernelnewbies.org/FAQ/WhyWritingFilesFromKernelIsBad
> discusses this.

Thanks, I have missed this faq.

> Userspace could write the necessary configuration data into
> the kernel,
> for example a sysfs attribute.  Of course the attribute
> could also be
> readable.  But perhaps there are already established
> mechanisms for
> exactly this purpose.  I added Cc: netdev, maybe somebody
> there can give
> advice.

Thanks for the advice, I have another scenario where it should be nice to access files from inside the kernel, I am going to describe it on another email, but know I am not sure I should keep pursuint it.

Thanks again.



      Veja quais são os assuntos do momento no Yahoo! +Buscados
http://br.maisbuscados.yahoo.com
