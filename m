Return-Path: <linux-kernel-owner+w=401wt.eu-S1763350AbXGFPsO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763350AbXGFPsO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 11:48:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760184AbXGFPsA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 11:48:00 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:35672 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753564AbXGFPsA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 11:48:00 -0400
Date: Fri, 6 Jul 2007 08:49:10 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: "Robert P. J. Day" <rpjday@mindspring.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, gregkh@suse.de
Subject: Re: [PATCH] USB:  Remove Makefile reference to obsolete OHCI_AT91.
Message-Id: <20070706084910.4e5fc20f.randy.dunlap@oracle.com>
In-Reply-To: <Pine.LNX.4.64.0707060623170.11885@localhost.localdomain>
References: <Pine.LNX.4.64.0707060623170.11885@localhost.localdomain>
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

On Fri, 6 Jul 2007 06:24:20 -0400 (EDT) Robert P. J. Day wrote:

> 
> Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>
> 
> ---
> 
> diff --git a/drivers/usb/Makefile b/drivers/usb/Makefile
> index 72464b5..4d65404 100644
> --- a/drivers/usb/Makefile
> +++ b/drivers/usb/Makefile
> @@ -15,7 +15,6 @@ obj-$(CONFIG_USB_OHCI_HCD)	+= host/
>  obj-$(CONFIG_USB_UHCI_HCD)	+= host/
>  obj-$(CONFIG_USB_SL811_HCD)	+= host/
>  obj-$(CONFIG_USB_U132_HCD)	+= host/
> -obj-$(CONFIG_USB_OHCI_AT91)	+= host/
> 
>  obj-$(CONFIG_USB_ACM)		+= class/
>  obj-$(CONFIG_USB_PRINTER)	+= class/
> -- 

Please use subsystem mailing lists instead of using lkml for
Everything:

USB SUBSYSTEM
P:	Greg Kroah-Hartman
M:	gregkh@suse.de
L:	linux-usb-users@lists.sourceforge.net
L:	linux-usb-devel@lists.sourceforge.net
W:	http://www.linux-usb.org
T:	quilt kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/
S:	Supported


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
