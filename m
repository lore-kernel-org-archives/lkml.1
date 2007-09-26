Return-Path: <linux-kernel-owner+w=401wt.eu-S1761320AbXIZWCO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761320AbXIZWCO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 18:02:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751888AbXIZWB7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 18:01:59 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:49578 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754284AbXIZWB6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 18:01:58 -0400
Date: Wed, 26 Sep 2007 14:56:48 -0700
From: Greg KH <greg@kroah.com>
To: Jesse Barnes <jesse.barnes@intel.com>
Cc: linux-pci@atrey.karlin.mff.cuni.cz, Matthew Wilcox <matthew@wil.cx>,
       linux-kernel@vger.kernel.org, Robert Hancock <hancockr@shaw.ca>
Subject: Re: PCI: Fix boot-time hang on G31/G33 PC
Message-ID: <20070926215648.GA24505@kroah.com>
References: <20070826015556.GC14130@parisc-linux.org> <20070926211816.GA9916@kroah.com> <200709261455.56165.jesse.barnes@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200709261455.56165.jesse.barnes@intel.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 26, 2007 at 02:55:55PM -0700, Jesse Barnes wrote:
> On Wednesday, September 26, 2007 2:18 pm Greg KH wrote:
> > Due to the issues surrounding this patch, I'm dropping it from my
> > repo.
> 
> What issues?  Is it causing problems for people?

I thought this was the patch that Ivan objected to.

thanks,

greg k-h
