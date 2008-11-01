Return-Path: <linux-kernel-owner+w=401wt.eu-S1753527AbYKAPE0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753527AbYKAPE0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2008 11:04:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751671AbYKAPES
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Nov 2008 11:04:18 -0400
Received: from mail1.radix.net ([207.192.128.31]:35007 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751479AbYKAPES (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2008 11:04:18 -0400
X-Greylist: delayed 1726 seconds by postgrey-1.27 at vger.kernel.org; Sat, 01 Nov 2008 11:04:14 EDT
Subject: Re: [linux-dvb] [PATCH 1/7] Adding empia base driver
From: Andy Walls <awalls@radix.net>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Markus Rechberger <mrechberger@gmail.com>,
       v4l <video4linux-list@redhat.com>, linux-dvb@linuxtv.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       em28xx <em28xx@mcentral.de>
In-Reply-To: <200811011505.51716.hverkuil@xs4all.nl>
References: <200811011505.51716.hverkuil@xs4all.nl>
Content-Type: text/plain
Date: Sat, 01 Nov 2008 10:36:02 -0400
Message-Id: <1225550162.3129.7.camel@palomino.walls.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-8.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2008-11-01 at 15:05 +0100, Hans Verkuil wrote:

> Hi Markus,
> 
> As promised I've done a review of your empia driver and looked at what 
> needs to be done to get it into the kernel.
> 
> First of all, I've no doubt that your empia driver is better and 
> supports more devices than the current em28xx driver. I also have no 
> problem adding your driver separate from the current driver. It's been 
> done before (certain networking drivers spring to mind) and while 
> obviously not ideal I expect that the older em28xx driver can probably 
> be removed after a year or something like that.

[snip]

> So my recommendation would be to:

[snip]

> 3) Switch to video_ioctl2 in the empia driver. You can do that, but we 
> can probably find a volunteer as well.
> 
> 4) Conform the code to the coding style. If several people can help with 
> this we can get it done pretty quickly.

I can support these two portions of the effort, if what Hans' proposes
is the agreed plan.

Point me to the target directories in the repo, and suggest desired
completion dates for whatever tasks.

Standing by...

Regards,
Andy


