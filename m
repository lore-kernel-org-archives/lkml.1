Return-Path: <linux-kernel-owner+w=401wt.eu-S1758787AbXGIBPQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758787AbXGIBPQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2007 21:15:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756872AbXGIBPF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jul 2007 21:15:05 -0400
Received: from adsl-67-120-171-161.dsl.lsan03.pacbell.net ([67.120.171.161]:49927
	"HELO linuxace.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755016AbXGIBPD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2007 21:15:03 -0400
X-Greylist: delayed 401 seconds by postgrey-1.27 at vger.kernel.org; Sun, 08 Jul 2007 21:15:03 EDT
Date: Sun, 8 Jul 2007 18:08:22 -0700
From: Phil Oester <kernel@linuxace.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.22 released
Message-ID: <20070709010822.GA32652@linuxace.com>
References: <alpine.LFD.0.999.0707081639370.31544@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.999.0707081639370.31544@woody.linux-foundation.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 08, 2007 at 04:52:52PM -0700, Linus Torvalds wrote:
> Anybody? Should I make just the shortlogs available instead (I don't save 
> those, but I post those for the later -rc's - usually the -rc1 and -rc2's 
> are too big for the mailing list, but they are still a lot smaller and 
> more readable than the *full* logs are)?
> 
> Or do people really want the full logs, and don't use git?

I don't use git, and sometimes find it useful to view the changelogs to look
for when a particular change occurred.  Doing so via:

	http://kernel.org/pub/linux/kernel/v2.6/ChangeLog-2.6.X

where X is decremented from current rev is handy.  Please keep them around.

Phil
