Return-Path: <linux-kernel-owner+w=401wt.eu-S1030477AbXC2RZT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030477AbXC2RZT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2007 13:25:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030510AbXC2RZS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Mar 2007 13:25:18 -0400
Received: from smtp.osdl.org ([65.172.181.24]:33524 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933166AbXC2RZP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2007 13:25:15 -0400
Date: Thu, 29 Mar 2007 10:22:51 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Maxim Levitsky <maximlevitsky@gmail.com>
cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Jeff Chua <jeff.chua.linux@gmail.com>, Adrian Bunk <bunk@stusta.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, pavel@suse.cz,
       linux-pm@lists.osdl.org, gregkh@suse.de,
       linux-pci@atrey.karlin.mff.cuni.cz, Jens Axboe <jens.axboe@oracle.com>,
       Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
       jgarzik@pobox.com, linux-ide@vger.kernel.org,
       "Michael S. Tsirkin" <mst@mellanox.co.il>
Subject: Re: [ PATCH] Add suspend/resume for HPET was: Re: [3/6] 2.6.21-rc4:
 known regressions
In-Reply-To: <200703291851.19424.maximlevitsky@gmail.com>
Message-ID: <Pine.LNX.4.64.0703291022100.6730@woody.linux-foundation.org>
References: <Pine.LNX.4.64.0703160925270.26106@woody.linux-foundation.org>
 <200703290747.28929.maximlevitsky@gmail.com>
 <Pine.LNX.4.64.0703290930540.6730@woody.linux-foundation.org>
 <200703291851.19424.maximlevitsky@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 29 Mar 2007, Maxim Levitsky wrote:
>
> 	I agree, and as you said I did exactly that:

Gaah. I'm blind. Sorry. Your patch did indeed do exactly that, I somehow 
overlooked it.

		Linus
