Return-Path: <linux-kernel-owner+w=401wt.eu-S1422652AbXBHDsW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422652AbXBHDsW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 22:48:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422670AbXBHDsW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 22:48:22 -0500
Received: from cantor.suse.de ([195.135.220.2]:36974 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422652AbXBHDsW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 22:48:22 -0500
Date: Wed, 7 Feb 2007 19:47:12 -0800
From: Greg KH <gregkh@suse.de>
To: Jeff Garzik <jeff@garzik.org>
Cc: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>,
       linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz,
       pcihpd-discuss@lists.sourceforge.net
Subject: Re: [GIT PATCH] PCI patches for 2.6.20
Message-ID: <20070208034712.GA9023@suse.de>
References: <20070208002932.GC4796@kroah.com> <45CA9638.2010209@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45CA9638.2010209@garzik.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 07, 2007 at 10:17:12PM -0500, Jeff Garzik wrote:
> Greg KH wrote:
> >Greg Kroah-Hartman (3):
> >      PCI: remove duplicate device id from ata_piix
> >      PCI: remove duplicate device id from ipr
> >      Revert "PCI: remove duplicate device id from ata_piix"
> 
> 
> If these are coming out of quilt, why add these commit-then-revert 
> changesets at all?

I commited them all out of quilt, and then realized that I had applied
one in the middle that I shouldn't have.  So I then used git to just
revert it.

Sorry for the confusion.

greg k-h
