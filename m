Return-Path: <linux-kernel-owner+w=401wt.eu-S1756187AbYCaM5S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756187AbYCaM5S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 08:57:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753930AbYCaM5K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 08:57:10 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:39341 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754090AbYCaM5J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 08:57:09 -0400
Date: Mon, 31 Mar 2008 15:56:53 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Chr <chunkeey@web.de>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-kernel@vger.kernel.org, Andi Kleen <andi-suse@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: The never ending BEEEEP/__smp_call_function_mask with
	2.6.25-rc7
Message-ID: <20080331125653.GA32334@cs181133002.pp.htv.fi>
References: <200803302109.22219.chunkeey@web.de> <200803302218.52549.chunkeey@web.de> <alpine.LFD.1.10.0803302236180.3219@apollo.tec.linutronix.de> <200803302309.52493.chunkeey@web.de> <alpine.LFD.1.10.0803302315270.3219@apollo.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0803302315270.3219@apollo.tec.linutronix.de>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 30, 2008 at 11:36:40PM +0200, Thomas Gleixner wrote:
> On Sun, 30 Mar 2008, Chr wrote:
>...
> You mentioned that you have tons of other logs. Can you please
> upload those to some place? If you don't have a possiblity, please
> contact me private and I'll provide you one.

The logical place would be
  http://bugzilla.kernel.org/show_bug.cgi?id=10369

And linux-kernel has a size limit of 400 kB, so everything that is 
smaller (at least when compressed) could simply be sent by email.

> Thanks,
> 
> 	tglx

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

