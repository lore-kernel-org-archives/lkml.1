Return-Path: <linux-kernel-owner+w=401wt.eu-S1755210AbXFSMj5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755210AbXFSMj5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 08:39:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756599AbXFSMjr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 08:39:47 -0400
Received: from moutng.kundenserver.de ([212.227.126.177]:50528 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756260AbXFSMjq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 08:39:46 -0400
Message-ID: <4677CE85.6080002@anagramm.de>
Date: Tue, 19 Jun 2007 14:39:33 +0200
From: Clemens Koller <clemens.koller@anagramm.de>
User-Agent: Thunderbird 1.5.0.12 (Windows/20070509)
MIME-Version: 1.0
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Jarek Poplawski <jarkao2@o2.pl>,
       Mariusz Kozlowski <m.kozlowski@tuxland.pl>,
       Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [ANNOUNCE] Linux Kernel =?UTF-8?B?VGVzdGVy4oCZcyBHdWlkZSB2MC4=?=
 =?UTF-8?B?My1yYzE=?=
References: <4676E707.8020109@googlemail.com>
In-Reply-To: <4676E707.8020109@googlemail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Provags-ID: V01U2FsdGVkX19Mgq0QkJUA3+qP+xYF+zx+UqGpJbM4p4I5gW9
 OgosGaEVr9SjqZkJ1IHuhncfD7VSJAwq0YwsTgUMUVm+zY02bK
 AqFi6IU3rlptiAbeJCJhg==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Michal, Rafael!

Good work!
Some (minor) comments below.

Michal Piotrowski schrieb:
> Hi,
> 
> We are pleased to announce the availability of "Linux Kernel Tester's 
> Guide" v0.3-rc1.
> 
> This short guide describes the basics of kernel testing. The handbook is 
> divided into six chapters:
> 
> 1 The kernel, patches, trees and compilation
>  1.1 The kernel

I would prefer to use a -rc in the examples and not one of the
stable 2.6.x.y kernels.

>  1.2 Patches
>  1.3 Ketchup

I would prefer using git in the examples.
There is no such thing as "apt-get" in generic linux.

> Any comments, suggestions and patches are welcome.

There is just too less time to test the kernel much in
detail. It would be fine to have the whole book as
./test-my-system-now-but-dont-ask-me.sh ;-)

Good luck,
-- 
Clemens Koller
__________________________________
R&D Imaging Devices
Anagramm GmbH
Rupert-Mayer-Straße 45/1
Linhof Werksgelände
D-81379 München
Tel.089-741518-50
Fax 089-741518-19
http://www.anagramm-technology.com
