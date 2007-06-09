Return-Path: <linux-kernel-owner+w=401wt.eu-S1761637AbXFII3V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761637AbXFII3V (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jun 2007 04:29:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752828AbXFII3J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jun 2007 04:29:09 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:59500 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752417AbXFII3H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jun 2007 04:29:07 -0400
Message-ID: <466A64CA.5050908@garzik.org>
Date: Sat, 09 Jun 2007 04:28:58 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
CC: Jiri Slaby <jirislaby@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Ingo Korb <ml@akana.de>, linux-ide@vger.kernel.org
Subject: Re: [PATCH 1/1] ide: ide-generic, add another device exception
References: <20601315171560711667@wsc.cz> <200706081418.56217.bzolnier@gmail.com> <20070608135931.GB24346@havoc.gtf.org> <200706082241.24233.bzolnier@gmail.com>
In-Reply-To: <200706082241.24233.bzolnier@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Bartlomiej Zolnierkiewicz wrote:
> Hi,
> 
> On Friday 08 June 2007, Jeff Garzik wrote:
>> On Fri, Jun 08, 2007 at 02:18:55PM +0200, Bartlomiej Zolnierkiewicz wrote:
>>> On Monday 04 June 2007, Jiri Slaby wrote:
>>>> ide-generic, add another device exception
>>> ide-generic is a generic ISA IDE driver, this one is drivers/ide/pci/generic
>>> (a generic IDE PCI driver) - fixed patch description to avoid confusion.
>>>
>>> [ Yes, both drivers need a rename - patches are welcomed. ]
>> Probably best to do a rename from your side, in git.
> 
> AFAIR git-quiltimport of quilt patches should handle this just fine?

'git mv old_name new_name'


