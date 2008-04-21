Return-Path: <linux-kernel-owner+w=401wt.eu-S1760406AbYDUOLg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760406AbYDUOLg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 10:11:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755006AbYDUOL2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 10:11:28 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:34253 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754369AbYDUOL1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 10:11:27 -0400
Date: Mon, 21 Apr 2008 17:10:58 +0300
From: Adrian Bunk <bunk@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>, Andrey Panin <pazke@donpac.ru>
Cc: Ingo Molnar <mingo@elte.hu>, Alexey Starikovskiy <astarikovskiy@suse.de>,
       tglx@linutronix.de, James.Bottomley@HansenPartnership.com,
       linux-kernel@vger.kernel.org
Subject: Status of SGI 320/540 (Visual Workstation) support?
Message-ID: <20080421141058.GH6011@cs181133002.pp.htv.fi>
References: <20080421000238.GD26897@cs181133002.pp.htv.fi> <20080421085314.GI26897@cs181133002.pp.htv.fi> <20080421120054.GA6788@elte.hu> <480C8EC8.3080705@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <480C8EC8.3080705@zytor.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 21, 2008 at 08:55:36AM -0400, H. Peter Anvin wrote:
>...
> VISWS is another matter.  It's entirely possible I have the only  
> remaining VISWS in my garage; we have at least not been able to locate  
> another.  Not that we have tried all that hard.
>
> If there are no VISWS' left, we should just unload the code.

Googling a bit around 320/540 hardware does not seem to have completely 
vanished from the earth, and there are still people who'd like to 
install Linux on them.

Looking through the archives of the mailing list in MAINTAINERS there 
seem to be some older 2.6 kernels that worked on some Visual 
Workstations, but no indication that recent kernels work.

Andrey, what is the status of recent 2.6 kernels on the SGI 320/540?

> 	-hpa

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

