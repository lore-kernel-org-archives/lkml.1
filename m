Return-Path: <linux-kernel-owner+w=401wt.eu-S1758159AbXFUGvG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758159AbXFUGvG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 02:51:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753000AbXFUGu4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 02:50:56 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:18866 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751580AbXFUGuz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 02:50:55 -0400
Date: Thu, 21 Jun 2007 08:50:54 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
cc: LKML <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Jarek Poplawski <jarkao2@o2.pl>,
       Mariusz Kozlowski <m.kozlowski@tuxland.pl>,
       Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [ANNOUNCE] Linux Kernel =?UTF-8?B?VGVzdGVy4oCZcyBHdWlkZSB2MC4zLXI=?=
 =?UTF-8?B?YzE=?=
In-Reply-To: <4676E707.8020109@googlemail.com>
Message-ID: <Pine.LNX.4.64.0706210829040.20010@fbirervta.pbzchgretzou.qr>
References: <4676E707.8020109@googlemail.com>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-699020219-106555721-1182408654=:20010"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---699020219-106555721-1182408654=:20010
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT


<On Jun 18 2007 22:11, Michal Piotrowski wrote:
>
> 1 The kernel, patches, trees and compilation
> 1.1 The kernel

Please do not advocate old-style tar option syntax.

> 1.2 Patches
> 1.3 Ketchup
> 1.4 Trees
> 1.5 The -mm tree
> 1.6 Compilation and installation
>   1.6.1 Kernel compilation
>   1.6.2 Useful make options

make O=/katalog  seems out of place.

>   1.6.3 Kernel modules
>   1.6.4 Kernel hacking options
>   1.6.5 Magic SysRq
>   1.6.6 Installation
>   1.6.7 Automated conﬁguration and installation
> 2 Testing
> 2.1 Phase One
> 2.2 Phase Two (AutoTest)
> 2.3 Phase Three
> 2.4 Measuring performance
> 2.5 Hello world! or What exactly are we looking for?
> 2.6 Binary drivers and distribution kernels
> 3 Collecting kernel messages
> 3.1 Syslog, console and dmesg
> 3.2 Serial console

Or set up minicom first... minicom -s ttyS0 (and then go to Serial port setup)

> PDF version
> http://www.stardust.webpages.pl/files/handbook/handbook-en-0.3-rc1.pdf

No HTML version?

>
> LaTeX source
> http://www.stardust.webpages.pl/files/handbook/handbook-current.tar.bz2
>
> Any comments, suggestions and patches are welcome.
>
> Huge thanks goes to Rafael J. Wysocki who translated the entire guide into
> English.
> This is one of those rare cases when translation is better than original
> version :).
>

	Jan
-- 
---699020219-106555721-1182408654=:20010--
