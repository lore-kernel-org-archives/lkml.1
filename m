Return-Path: <linux-kernel-owner+w=401wt.eu-S1764293AbXHOOrh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764293AbXHOOrh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 10:47:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760035AbXHOOr0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 10:47:26 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:60194 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758225AbXHOOrZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 10:47:25 -0400
Date: Wed, 15 Aug 2007 08:47:23 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: "Igor A. Nesterov" <igor.nesterov@indexengines.com>
Cc: James.Smart@Emulex.Com, Tore Anderson <tore@linpro.no>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-scsi@vger.kernel.org
Subject: Re: Linux 2.6.23-rc3
Message-ID: <20070815144723.GZ16277@parisc-linux.org>
References: <alpine.LFD.0.999.0708122143240.30176@woody.linux-foundation.org> <46C1717E.3030908@linpro.no> <20070814112429.GL16277@parisc-linux.org> <46C1A866.5090903@emulex.com> <1187186897.1457.57.camel@potomac.tworiverlabs.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1187186897.1457.57.camel@potomac.tworiverlabs.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 15, 2007 at 10:08:17AM -0400, Igor A. Nesterov wrote:
> So would it be true to say that the fix for -EEXIST problem still has
> not found its way to mainline kernel? I've been hit by this problem
> after switching to Fedora 7, and currently running on Fedora
> 2.6.21-1.3228 kernel patched with one of those fixes above. I always
> hoped that 2.6.22 will be free of this problem, but apparently it still
> exists even in 2.6.23.

James Bottomley just added it to the tree that will be pushed for the
2.6.24 merge window.  I'd wish for it to be added to 2.6.23 too, since
it does fix a bug, but it's his decision, not mine.

-- 
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
