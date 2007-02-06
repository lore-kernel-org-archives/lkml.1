Return-Path: <linux-kernel-owner+w=401wt.eu-S932606AbXBFRvY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932606AbXBFRvY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 12:51:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933018AbXBFRvY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 12:51:24 -0500
Received: from ns.suse.de ([195.135.220.2]:33720 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932606AbXBFRvX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 12:51:23 -0500
Date: Tue, 6 Feb 2007 18:51:03 +0100
From: Stefan Seyfried <seife@suse.de>
To: Christian Axelsson <smiler@lanil.mine.nu>
Cc: suspend-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [Suspend-devel] [swsusp] s2ram fails to restore graphics
Message-ID: <20070206175103.GA8604@suse.de>
References: <45C8B688.1080105@lanil.mine.nu> <45C8B87E.9090603@lanil.mine.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <45C8B87E.9090603@lanil.mine.nu>
X-Operating-System: openSUSE 10.2 (i586), Kernel 2.6.18.2-34-default
User-Agent: mutt-ng/devel-r804 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 06, 2007 at 06:18:54PM +0100, Christian Axelsson wrote:
> Ups, forgot suspend-devel CC :)
> 
> Christian Axelsson wrote:
> > Hello!
> > 
> > I'm having problems with s2ram being unable to restore my Intel 945GM (a 
> > Dell D420 laptop) when resuming. I think everything else is restored 
> > properly (I have input so I can reboot or suspend again). Full 
> > hibernation is working flawless on this machine including restoring 
> > framebuffer and X (kudos to the suspend team :).
> > 
> > I've tried both with and without framebuffer on 2.6.20.
> > Using the vbetool-trick brings the backlight on (it's otherwise off 
> > after resume).

Which of the three vbetool tricks?

The machine is in the whitelist and i have personally seen a D420 resume with
the workarounds from the whitelist entry.

I strongly suggest that this is not a kernel problem but a user(space)
problem :-)
-- 
Stefan Seyfried
QA / R&D Team Mobile Devices        |              "Any ideas, John?"
SUSE LINUX Products GmbH, Nürnberg  | "Well, surrounding them's out." 
