Return-Path: <linux-kernel-owner+w=401wt.eu-S1754049Ab0AXQhn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754049Ab0AXQhn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jan 2010 11:37:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754085Ab0AXQhl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jan 2010 11:37:41 -0500
Received: from www.tglx.de ([62.245.132.106]:59648 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754075Ab0AXQhj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jan 2010 11:37:39 -0500
Date: Sun, 24 Jan 2010 17:37:31 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Greg KH <gregkh@suse.de>
cc: Nathan Williams <ngwilliams@gmail.com>,
       Ozan ??a??layan <ozan@pardus.org.tr>, linux-kernel@vger.kernel.org
Subject: Re: [REGRESSION] clockevents patch causes hang on power off
In-Reply-To: <20100123152421.GA15855@suse.de>
Message-ID: <alpine.LFD.2.00.1001241736520.2906@localhost.localdomain>
References: <b4e196fa1001221721y19ae3a50wa21a6b54627b3852@mail.gmail.com> <4B5AD2C3.4020409@pardus.org.tr> <b4e196fa1001230322u558f7af5j5f27844088895a0@mail.gmail.com> <20100123152421.GA15855@suse.de>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 23 Jan 2010, Greg KH wrote:

> On Sat, Jan 23, 2010 at 10:22:10PM +1100, Nathan Williams wrote:
> > 2010/1/23 Ozan ??a??layan <ozan@pardus.org.tr>:
> > > Nathan Williams wrote:
> > >> I'm having trouble with my PC crashing just as it's attempting to power off.
> > >> I managed to git bisect to this commit:
> > >>
> > >
> > > http://bugzilla.kernel.org/show_bug.cgi?id=15037
> > > http://patchwork.kernel.org/patch/71537/
> > >
> > 
> > Thanks. The patch works for me.
> 
> What's the plan on getting that patch into Linus's tree for .33?

Pull request is sent. Thanks,

     tglx


