Return-Path: <linux-kernel-owner+w=401wt.eu-S1757649AbXGKCju@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757649AbXGKCju (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 22:39:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753100AbXGKCjm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 22:39:42 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:52846 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752607AbXGKCji (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 22:39:38 -0400
Date: Tue, 10 Jul 2007 19:42:47 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Dave Young <hidave.darkstar@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH][DOC]hpet.txt broken link fix
Message-Id: <20070710194247.a41fc2d1.randy.dunlap@oracle.com>
In-Reply-To: <20070711100417.GA2013@darkstar.te-china.tietoenator.com>
References: <20070711100417.GA2013@darkstar.te-china.tietoenator.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Jul 2007 10:04:17 +0000 Dave Young wrote:

> The specification link in hpet document is broken.

OK.  Sadly it's a moving target.
Thanks.

> Signed-off-by: Dave Young <hidave.darkstar@gmail.com> 
> 
> ---
> Documentation/hpet.txt |    2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff -pur linux/Documentation/hpet.txt linux.new/Documentation/hpet.txt
> --- linux/Documentation/hpet.txt	2007-07-11 09:37:24.000000000 +0000
> +++ linux.new/Documentation/hpet.txt	2007-07-11 09:46:33.000000000 +0000
> @@ -5,7 +5,7 @@ for the 8254 and Real Time Clock (RTC) p
>  Each HPET can have up to 32 timers.  It is possible to configure the
>  first two timers as legacy replacements for 8254 and RTC periodic timers.
>  A specification done by Intel and Microsoft can be found at
> -<http://www.intel.com/hardwaredesign/hpetspec.htm>.
> +<http://www.intel.com/technology/architecture/hpetspec.htm>.
>  
>  The driver supports detection of HPET driver allocation and initialization
>  of the HPET before the driver module_init routine is called.  This enables


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
