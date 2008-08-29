Return-Path: <linux-kernel-owner+w=401wt.eu-S1758674AbYH2RJs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758674AbYH2RJs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 13:09:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756337AbYH2RJk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 13:09:40 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:53290 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755578AbYH2RJj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 13:09:39 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Linux 2.6.27-rc5
Date: Fri, 29 Aug 2008 19:13:25 +0200
User-Agent: KMail/1.9.9
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jeff Garzik <jeff@garzik.org>, Tejun Heo <htejun@gmail.com>
References: <alpine.LFD.1.10.0808281555230.3300@nehalem.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0808281555230.3300@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808291913.26585.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 29 of August 2008, Linus Torvalds wrote:
> 
> Another week (my weeks do seem to be eight days, don't they? Very odd), 
> another -rc.
> 
> The dirstat pretty much says it all:
> 
>   43.0% arch/arm/configs/
>   43.9% arch/arm/
>   25.5% arch/powerpc/configs/
>   26.8% arch/powerpc/
>   73.9% arch/
>    4.4% drivers/usb/musb/
>    5.4% drivers/usb/
>    4.0% drivers/watchdog/
>   16.0% drivers/
>    3.5% fs/
> 
> yeah, the bulk of it is all config updates, and with arm and powerpc 
> leading the pack.

Doesn't boot on my quad core test box, apparently because of an AHCI failure.

Bisecting ...

Rafael
