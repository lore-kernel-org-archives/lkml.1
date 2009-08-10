Return-Path: <linux-kernel-owner+w=401wt.eu-S1753188AbZHJUsn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753188AbZHJUsn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 16:48:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753016AbZHJUsm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 16:48:42 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:49485 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752710AbZHJUsl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 16:48:41 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Greg KH <gregkh@suse.de>
Subject: Re: [PATCH] PM: kill dev_pm_ops platform warning for now
Date: Mon, 10 Aug 2009 22:49:12 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.31-rc5-rjw; KDE/4.3.0; x86_64; ; )
Cc: Magnus Damm <magnus.damm@gmail.com>, linux-pm@lists.linux-foundation.org,
       lethal@linux-sh.org, stern@rowland.harvard.edu, pavel@ucw.cz,
       LKML <linux-kernel@vger.kernel.org>
References: <20090807083430.31389.98825.sendpatchset@rx1.opensource.se> <200908081516.24018.rjw@sisk.pl> <20090810164542.GA28405@suse.de>
In-Reply-To: <20090810164542.GA28405@suse.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200908102249.12638.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 10 August 2009, Greg KH wrote:
> On Sat, Aug 08, 2009 at 03:16:23PM +0200, Rafael J. Wysocki wrote:
> > On Friday 07 August 2009, Magnus Damm wrote:
> > > From: Magnus Damm <damm@igel.co.jp>
> > > 
> > > Remove the platform device runtime dev_pm_ops warning
> > > for now. No point in upsetting users of non-rc kernels.
> > > 
> > > Signed-off-by: Magnus Damm <damm@igel.co.jp>
> > 
> > Thanks for the patch, I modified the changelog a bit.
> > 
> > Greg, do you agree with the patch below?
> 
> Yes, feel free to add:
> 	Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
> to the patch and forward it on.
> 
> Or do you need me to forward it?

If you have anything more to push to Linus, please push this patch along with
it with my ACK.  Otherwise, please let me know and I'll push it.

Thanks,
Rafael
