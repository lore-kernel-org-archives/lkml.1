Return-Path: <linux-kernel-owner+w=401wt.eu-S1752811AbXHZMzx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752811AbXHZMzx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Aug 2007 08:55:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751921AbXHZMzo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Aug 2007 08:55:44 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:51510 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751526AbXHZMzn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Aug 2007 08:55:43 -0400
Date: Sun, 26 Aug 2007 06:55:42 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Robert Hancock <hancockr@shaw.ca>
Cc: linux-pci@atrey.karlin.mff.cuni.cz, linux-kernel@vger.kernel.org,
       Jesse Barnes <jesse.barnes@intel.com>, Greg KH <greg@kroah.com>
Subject: Re: [PATCH] Fix boot-time hang on G31/G33 PC
Message-ID: <20070826125542.GD14130@parisc-linux.org>
References: <20070826015556.GC14130@parisc-linux.org> <46D10099.40401@shaw.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46D10099.40401@shaw.ca>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 25, 2007 at 10:24:57PM -0600, Robert Hancock wrote:
> We've already got a patch for this in Greg's PCI tree, hopefully it 
> should go in for 2.6.24.

I haven't seen it.  I guess it wasn't sent to the PCI mailing list.

Your patch had two or three problems with it; assuming we're talking
about the same patch.

> Are you getting MMCONFIG enabled on your system with 2.6.23?

Yes, I have to pass pci=nommconf to make it boot.

-- 
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
