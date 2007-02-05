Return-Path: <linux-kernel-owner+w=401wt.eu-S1751855AbXBEQ5s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751855AbXBEQ5s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 11:57:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751860AbXBEQ5s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 11:57:48 -0500
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:43249 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751850AbXBEQ5r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 11:57:47 -0500
Date: Mon, 5 Feb 2007 09:04:17 -0800
From: Chris Wright <chrisw@sous-sol.org>
To: Kumar Gala <galak@kernel.crashing.org>
Cc: Chris Wright <chrisw@sous-sol.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>, stable@kernel.org,
       Greg KH <greg@kroah.com>, Andrew Morton <akpm@osdl.org>
Subject: Re: [patch 17/59] PCI: prevent down_read when pci_devices is empty
Message-ID: <20070205170417.GQ10475@sequoia.sous-sol.org>
References: <20070203023504.435051000@sous-sol.org> <20070203024013.737331000@sous-sol.org> <5EFB4FBE-A880-4078-A5A1-74F4C22FF93A@kernel.crashing.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5EFB4FBE-A880-4078-A5A1-74F4C22FF93A@kernel.crashing.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Kumar Gala (galak@kernel.crashing.org) wrote:
> 
> On Feb 2, 2007, at 8:35 PM, Chris Wright wrote:
> 
> >-stable review patch.  If anyone has any objections, please let us  
> >know.
> >------------------
> 
> We just updated this for mainline to remove the printks.  I'd prefer  
> to see that version of this patch go in.

Thanks, I was able to fold that minor simplification in.
-chris
