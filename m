Return-Path: <linux-kernel-owner+w=401wt.eu-S934095AbXCFMLm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934095AbXCFMLm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 07:11:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934098AbXCFMLm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 07:11:42 -0500
Received: from dev.mellanox.co.il ([194.90.237.44]:36080 "EHLO
	dev.mellanox.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934093AbXCFMLk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 07:11:40 -0500
Date: Tue, 6 Mar 2007 14:08:08 +0200
From: "Michael S. Tsirkin" <mst@mellanox.co.il>
To: Jeff Chua <jeff.chua.linux@gmail.com>
Cc: Adrian Bunk <bunk@stusta.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Pavel Machek <pavel@ucw.cz>, linux-pm@lists.osdl.org,
       Ingo Molnar <mingo@elte.hu>, lenb@kernel.org,
       linux-acpi@vger.kernel.org
Subject: Re: 2.6.21-rc1: known regressions (v2) (part 1)
Message-ID: <20070306120808.GA9537@mellanox.co.il>
Reply-To: "Michael S. Tsirkin" <mst@mellanox.co.il>
References: <Pine.LNX.4.64.0702202043280.4043@woody.linux-foundation.org> <20070226220152.GA29575@stusta.de> <20070228211318.GB4301@mellanox.co.il> <b6a2187b0702281945n5f62a6b5w1c535de3ef9aaa8f@mail.gmail.com> <20070305000421.GF3441@stusta.de> <b6a2187b0703051732v79a532f6mbf0d3da857a914e6@mail.gmail.com> <b6a2187b0703060403o48130853m9393df70160303c1@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b6a2187b0703060403o48130853m9393df70160303c1@mail.gmail.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Quoting Jeff Chua <jeff.chua.linux@gmail.com>:
> Subject: Re: 2.6.21-rc1: known regressions (v2) (part 1)
> 
> On 3/6/07, Jeff Chua <jeff.chua.linux@gmail.com> wrote:
> > On 3/5/07, Adrian Bunk <bunk@stusta.de> wrote:
> >
> > > > I have the same problem on my IBM X60s on rc1 and rc2. Can't resume
> > > > from RAM, can't suspend to disk. It is possible to revert all the
> > > > changes to ACPI and test it?
> > >
> > > This is with CONFIG_KVM=n?
> >
> > Yes.
> 
> I've tried with CONFIG_KVM=n and CONFIG_KVM=y and both does not suspend.

Do you mean that they "do not resume after suspend"?

-- 
MST
