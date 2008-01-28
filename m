Return-Path: <linux-kernel-owner+w=401wt.eu-S1756707AbYA1Oyd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756707AbYA1Oyd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 09:54:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753574AbYA1OyY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 09:54:24 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:34597 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753418AbYA1OyX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 09:54:23 -0500
Date: Mon, 28 Jan 2008 20:27:22 +0530
From: Sudhir Kumar <skumar@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Sudhir Kumar <skumar@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>, Balbir Singh <balbir@in.ibm.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>
Subject: Re: 2.6.24-rc8-mm1 Kernel BUG while bootup
Message-ID: <20080128145722.GB25517@in.ibm.com>
Reply-To: skumar@linux.vnet.ibm.com
References: <20080122135800.GA6084@in.ibm.com> <20080122155329.GA30119@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080122155329.GA30119@elte.hu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 22, 2008 at 04:53:30PM +0100, Ingo Molnar wrote:
> 
Hi Ingo,
I applied all the hot fixes patches but still the bug is there.
(crash at early boot).

As I replied your earlier mail in which the patch sent by you
does not apply (reverse).
can you please look into the problem ?

Thanks
Sudhir

> * Sudhir Kumar <skumar@linux.vnet.ibm.com> wrote:
> 
> > Hi Andrew,
> > 
> > I found a Bug at the very start of booting rc8-mm1 kernel on my 
> > machine. Following is the info of my machine: uname -a Linux 
> > x330d.in.ibm.com 2.6.24-rc6 #3 SMP Tue Jan 15 17:24:05 NPT 2008 i686 
> > i686 i386 GNU/Linux
> > 
> > Since I could capture a jpeg image of the boot message so I have put 
> > it at
> > 
> > http://imsudhirkumar.googlepages.com/home
> 
> i think this is an early bootup crash that has been resolved in x86.git.
> 
> 	Ingo
