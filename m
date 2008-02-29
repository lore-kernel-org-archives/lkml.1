Return-Path: <linux-kernel-owner+w=401wt.eu-S1756915AbYB2KSe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756915AbYB2KSe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 05:18:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754170AbYB2KSY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 05:18:24 -0500
Received: from nat-132.atmel.no ([80.232.32.132]:59289 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753608AbYB2KSX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 05:18:23 -0500
Date: Fri, 29 Feb 2008 11:17:31 +0100
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Matthew Wilcox <matthew@wil.cx>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>,
       Mark Fasheh <mark.fasheh@oracle.com>
Subject: Re: linux-next: semaphore update merge conflicts
Message-ID: <20080229111731.13840877@hskinnemoen.norway.atmel.com>
In-Reply-To: <20080229153958.fc34e281.sfr@canb.auug.org.au>
References: <20080229153958.fc34e281.sfr@canb.auug.org.au>
Organization: Atmel Norway
X-Mailer: Claws Mail 3.3.0 (GTK+ 2.12.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 29 Feb 2008 15:39:58 +1100
Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> 	arch/avr32/kernel/semaphore.c
> 		the avr32 tree appeared to just change spaces to tabs
> 		in this file so I removed it (as your changes did).

I yanked that change out of my tree. No point cleaning up that file if
it's going away.

Haavard
