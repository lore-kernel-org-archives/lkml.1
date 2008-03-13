Return-Path: <linux-kernel-owner+w=401wt.eu-S1756431AbYCMOyE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756431AbYCMOyE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 10:54:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753100AbYCMOxw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 10:53:52 -0400
Received: from mail.queued.net ([207.210.101.209]:1289 "EHLO mail.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752964AbYCMOxv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 10:53:51 -0400
Date: Thu, 13 Mar 2008 10:57:50 -0400
From: Andres Salomon <dilinger@queued.net>
To: Pavel Machek <pavel@ucw.cz>
Cc: Jordan Crouse <jordan.crouse@amd.com>, akpm@linux-foundation.org,
       kernel list <linux-kernel@vger.kernel.org>,
       Linux-pm mailing list <linux-pm@lists.osdl.org>,
       linux-fbdev-devel@lists.sourceforge.net, adaplas@pol.net,
       mm-commits@vger.kernel.org, rjw@sisk.pl
Subject: Re: +
 pm-gxfb-add-hook-to-pm-console-layer-that-allows-disabling-of-suspen
 d-vt-switch.patch added to -mm tree
Message-ID: <20080313105750.3e50107a@ephemeral>
In-Reply-To: <20080313074332.GA19117@elf.ucw.cz>
References: <200803120527.m2C5RmWl011967@imap1.linux-foundation.org>
	<20080312085149.GA3993@ucw.cz>
	<20080312144506.GE1018@cosmic.amd.com>
	<20080313074332.GA19117@elf.ucw.cz>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.12.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Mar 2008 08:43:32 +0100
Pavel Machek <pavel@ucw.cz> wrote:

[...]
> > 
> > > Also, it would be nice to make the logic the other way around. Move vt
> > > switching to the drivers that need it because X can be expected to own
> > > the hardware.
> > 
> > Conservation of energy.  Its easier to make 3 or 4 drivers opt out of 
> 
> Nice euphemism. You did quick hack instead of proper solution, and
> someone will have to clean it up sooner or later...
> 								Pavel
> 

And I wouldn't be willing to do anything further without approval
from the fbdevel folks.  No one's stopping you from writing a patch
if you feel so strongly about it, though.
