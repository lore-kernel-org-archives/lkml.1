Return-Path: <linux-kernel-owner+w=401wt.eu-S1752740AbXFKNoP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752740AbXFKNoP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 09:44:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751790AbXFKNoG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 09:44:06 -0400
Received: from waste.org ([66.93.16.53]:36246 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751812AbXFKNoF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 09:44:05 -0400
Date: Mon, 11 Jun 2007 08:43:26 -0500
From: Matt Mackall <mpm@selenic.com>
To: Greg KH <gregkh@suse.de>
Cc: Matthias Schniedermeyer <ms@citd.de>, Jesper Juhl <jesper.juhl@gmail.com>,
       Tsugikazu Shibata <tshibata@ab.jp.nec.com>,
       linux-kernel@vger.kernel.org, m-ikeda@ds.jp.nec.com
Subject: Re: [RFD] Documentation/HOWTO translated into Japanese
Message-ID: <20070611134326.GH11166@waste.org>
References: <20070610.204845.115909592.tshibata@ab.jp.nec.com> <9a8748490706100524o2dff1954ja7406f9303d8499f@mail.gmail.com> <20070610162221.GA12830@suse.de> <466C3B64.4070806@citd.de> <20070611060759.GB914@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070611060759.GB914@suse.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 10, 2007 at 11:07:59PM -0700, Greg KH wrote:
> So, Tsugikazu, care to resend this file as a patch that I can apply to
> the Documentation directory of the kernel tree?  I think it would be
> good to have there.

I'd rather have a single file, marked "Japanese" (in Japanese), that
had pointers to current translations. These will always be at least as
current as whatever we have in the tree, if not more so. Especially
when someone is trying to figure out how to work based on the year-old
kernel their embedded vendor gave them.

Further, it might be good for someone to be the "Japanese maintainer".
This person's job would be to accept patches from non-English-speaking
contributors, translate their commit messages and comments, then
forward them to the appropriate places (Andrew, subsystem maintainers,
LKML, etc.). They should also distill and translate feedback.

-- 
Mathematics is the supreme nostalgia of our time.
