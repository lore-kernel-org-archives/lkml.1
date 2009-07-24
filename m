Return-Path: <linux-kernel-owner+w=401wt.eu-S1754806AbZGXWDk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754806AbZGXWDk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jul 2009 18:03:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754758AbZGXWDk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Jul 2009 18:03:40 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:53517 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754757AbZGXWDj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jul 2009 18:03:39 -0400
From: "Madhusudhan" <madhu.cr@ti.com>
To: "'Adrian Hunter'" <adrian.hunter@nokia.com>,
       "'Linus Walleij'" <linus.walleij@stericsson.com>
Cc: "'Linus Walleij'" <linus.ml.walleij@gmail.com>,
       "'Andrew Morton'" <akpm@linux-foundation.org>,
       <linux-kernel@vger.kernel.org>, "'Pierre Ossman'" <pierre@ossman.eu>,
       <linux-arm-kernel@lists.arm.linux.org.uk>,
       "'David Vrabel'" <david.vrabel@csr.com>, <marek.vasut@gmail.com>
References: <1248128808-2241-1-git-send-email-linus.walleij@stericsson.com>	 <4A6701E3.3000204@csr.com> <63386a3d0907221533u6ab2738dpcb4484595ae757b0@mail.gmail.com> <4A68709E.5060207@csr.com> <4A68A8D9.1020207@nokia.com>
Subject: RE: [PATCH 1/2] MMC Agressive clocking framework v5
Date: Fri, 24 Jul 2009 17:03:01 -0500
Message-ID: <008801ca0caa$832f9df0$544ff780@am.dhcp.ti.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 11
Thread-Index: AcoLwZktuu8MQxVDQJ+Vz88eP3gA0gA6BOJw
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3198
In-Reply-To: <4A68A8D9.1020207@nokia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Adrian,

The patch #28 "The omap hsmmc driver code refactoring" in the series does
not seem to apply.

Regards,
Madhu 

> -----Original Message-----
> From: Adrian Hunter [mailto:adrian.hunter@nokia.com]
> Sent: Thursday, July 23, 2009 1:16 PM
> To: Linus Walleij
> Cc: Linus Walleij; Andrew Morton; linux-kernel@vger.kernel.org; Pierre
> Ossman; linux-arm-kernel@lists.arm.linux.org.uk; David Vrabel;
> marek.vasut@gmail.com; Madhusudhan Chikkature
> Subject: Re: [PATCH 1/2] MMC Agressive clocking framework v5
> 
> Hi
> 
> Have you considered using our enable/disable approach instead?
> 
> It is here:
> 
> http://groups.google.com/group/linux.kernel/browse_frm/thread/a5caec1de127
> 4be5/2ba7dee2a187a268
> 
> Perhaps it meets your needs, whereas your patches do not seem
> to cover the functionality we need.
> 
> Regards
> Adrian Hunter


