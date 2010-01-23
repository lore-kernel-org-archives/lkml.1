Return-Path: <linux-kernel-owner+w=401wt.eu-S1755885Ab0AWPdg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755885Ab0AWPdg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jan 2010 10:33:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755623Ab0AWPdg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jan 2010 10:33:36 -0500
Received: from cantor2.suse.de ([195.135.220.15]:53375 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753657Ab0AWPdf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jan 2010 10:33:35 -0500
Date: Sat, 23 Jan 2010 07:24:21 -0800
From: Greg KH <gregkh@suse.de>
To: Nathan Williams <ngwilliams@gmail.com>
Cc: Ozan ??a??layan <ozan@pardus.org.tr>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [REGRESSION] clockevents patch causes hang on power off
Message-ID: <20100123152421.GA15855@suse.de>
References: <b4e196fa1001221721y19ae3a50wa21a6b54627b3852@mail.gmail.com> <4B5AD2C3.4020409@pardus.org.tr> <b4e196fa1001230322u558f7af5j5f27844088895a0@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b4e196fa1001230322u558f7af5j5f27844088895a0@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 23, 2010 at 10:22:10PM +1100, Nathan Williams wrote:
> 2010/1/23 Ozan ??a??layan <ozan@pardus.org.tr>:
> > Nathan Williams wrote:
> >> I'm having trouble with my PC crashing just as it's attempting to power off.
> >> I managed to git bisect to this commit:
> >>
> >
> > http://bugzilla.kernel.org/show_bug.cgi?id=15037
> > http://patchwork.kernel.org/patch/71537/
> >
> 
> Thanks. The patch works for me.

What's the plan on getting that patch into Linus's tree for .33?

thanks,

greg k-h
