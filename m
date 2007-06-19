Return-Path: <linux-kernel-owner+w=401wt.eu-S1759616AbXFSQQx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759616AbXFSQQx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 12:16:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755891AbXFSQQq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 12:16:46 -0400
Received: from nz-out-0506.google.com ([64.233.162.232]:24139 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755818AbXFSQQp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 12:16:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=svTSqSm8qC8I5+oae4/E0GtVgTG0oEf8W4jncT6pUVzAoeEsU+W8Ufh4LcoEuqXD7CqGUdHWRDZ0pUqn1s+l5niKYrIxEIERExY7aa4EJSaMN07CYvLYzc7fcWDTM3fx236R5zSBLloy8oHy9nGbi6sjs9qRy1Kl+KseI3UZFck=
Message-ID: <6bffcb0e0706190916q50d92b3bpa718e760b09426d5@mail.gmail.com>
Date: Tue, 19 Jun 2007 18:16:43 +0200
From: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
To: "Clemens Koller" <clemens.koller@anagramm.de>
Subject: =?WINDOWS-1252?Q?Re:_[ANNOUNCE]_Linux_Kernel_Tester=92s_Guide_v0.3-rc1?=
Cc: LKML <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Maciej Rutecki" <maciej.rutecki@gmail.com>,
       "Bartlomiej Zolnierkiewicz" <bzolnier@gmail.com>,
       "Jarek Poplawski" <jarkao2@o2.pl>,
       "Mariusz Kozlowski" <m.kozlowski@tuxland.pl>,
       "Randy Dunlap" <randy.dunlap@oracle.com>
In-Reply-To: <4677CE85.6080002@anagramm.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4676E707.8020109@googlemail.com> <4677CE85.6080002@anagramm.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Clemens,

On 19/06/07, Clemens Koller <clemens.koller@anagramm.de> wrote:
> Hello, Michal, Rafael!
>
> Good work!

Thanks :)

> Some (minor) comments below.
>
> Michal Piotrowski schrieb:
> > Hi,
> >
> > We are pleased to announce the availability of "Linux Kernel Tester's
> > Guide" v0.3-rc1.
> >
> > This short guide describes the basics of kernel testing. The handbook is
> > divided into six chapters:
> >
> > 1 The kernel, patches, trees and compilation
> >  1.1 The kernel
>
> I would prefer to use a -rc in the examples and not one of the
> stable 2.6.x.y kernels.
>
> >  1.2 Patches
> >  1.3 Ketchup
>
> I would prefer using git in the examples.
> There is no such thing as "apt-get" in generic linux.
>
> > Any comments, suggestions and patches are welcome.
>
> There is just too less time to test the kernel much in
> detail. It would be fine to have the whole book as
> ./test-my-system-now-but-dont-ask-me.sh ;-)

How about "bin/autotest samples/all_tests"?

Regards,
Michal

-- 
LOG
http://www.stardust.webpages.pl/log/
