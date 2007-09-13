Return-Path: <linux-kernel-owner+w=401wt.eu-S1765632AbXIMSed@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765632AbXIMSed (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 14:34:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757451AbXIMSe0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 14:34:26 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:56576 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754375AbXIMSeZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 14:34:25 -0400
Date: Thu, 13 Sep 2007 20:35:48 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Abhishek Sagar <sagar.abhishek@gmail.com>
Cc: Denys Vlasenko <vda.linux@googlemail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] build system: section garbage collection for vmlinux
Message-ID: <20070913183548.GB27146@uranus.ravnborg.org>
References: <200709112105.34301.vda.linux@googlemail.com> <863e9df20709131126n182ec6f6l2c790bae4411d79e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <863e9df20709131126n182ec6f6l2c790bae4411d79e@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Abhisshek.

On Thu, Sep 13, 2007 at 11:56:14PM +0530, Abhishek Sagar wrote:
> On 9/12/07, Denys Vlasenko <vda.linux@googlemail.com> wrote:
> > Patches were run-tested on x86_64, and likely do not work on any other arch
> > (need to add KEEP() to arch/*/kernel/vmlinux.lds.S for each arch).
> 
> This is good stuff. I had been using a ported variant of this
> optimization for ARM on quite an older 2.6 kernel for a while now. I
> derived that port from:
> http://lkml.org/lkml/2006/6/4/169
> 
> With some tweaks it worked for me.
Could you post your tweaked version - against an older kernel is OK.

	Sam
