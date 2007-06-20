Return-Path: <linux-kernel-owner+w=401wt.eu-S1762484AbXFTF6B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762484AbXFTF6B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 01:58:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758423AbXFTF5x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 01:57:53 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51120 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757616AbXFTF5w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 01:57:52 -0400
Date: Tue, 19 Jun 2007 22:57:02 -0700
From: Greg KH <gregkh@suse.de>
To: dave young <hidave.darkstar@gmail.com>
Cc: Li Yang-r58472 <LeoLi@freescale.com>, WANG Cong <xiyou.wangcong@gmail.com>,
       linux-kernel@vger.kernel.org, TripleX Chung <xxx.phy@gmail.com>,
       Maggie Chen <chenqi@beyondsoft.com>, Tejun Heo <htejun@gmail.com>,
       Fengguang Wu <fengguang.wu@gmail.com>, Chen Li-jun <cljun@xiyou.edu.cn>
Subject: Re: [PATCH] Chinese translation of Documentation/HOWTO
Message-ID: <20070620055702.GA4794@suse.de>
References: <a8e1da0706191858w73a453dfjf28895150af85cfe@mail.gmail.com> <989B956029373F45A0B8AF0297081890D82DF1@zch01exm26.fsl.freescale.net> <a8e1da0706192222h1a47a103y38ea2b41b83ceb35@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a8e1da0706192222h1a47a103y38ea2b41b83ceb35@mail.gmail.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 20, 2007 at 05:22:49AM +0000, dave young wrote:
>  Hi,
>  2007/6/20, Li Yang-r58472 <LeoLi@freescale.com>:
> > > -----Original Message-----
> > > From: dave young [mailto:hidave.darkstar@gmail.com]
> > > Sent: Wednesday, June 20, 2007 9:58 AM
> > > To: WANG Cong
> > > Cc: Li Yang-r58472; linux-kernel@vger.kernel.org; gregkh@suse.de;
> > TripleX Chung;
> > > Maggie Chen; Tejun Heo; Fengguang Wu; Chen Li-jun
> > > Subject: Re: [PATCH] Chinese translation of Documentation/HOWTO
> > >
> > > Hi,
> > > IMHO, it is not very suitable  for translations  merging into kernel.
> > >
> > > first, It's impossible to be 100% accurate.
> >
> > It can be accurate by meaning.  And it can be improved.
> >
> > > second, two or more language need to be synced with english one, it's
> > > a problem in  the long run.
> >
> > This can be done through good maintenance.  I don't think it's harder
> > than maintaining the code in kernel source tree.
> 
>  Yes, but  the documents updating are always  late than the sources.

These files change _very_ slowly, only 5 minor changes in the past 3
years or so.  I think the translators can keep up with that :)

thanks,

greg k-h
