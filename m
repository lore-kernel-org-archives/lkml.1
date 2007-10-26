Return-Path: <linux-kernel-owner+w=401wt.eu-S1758588AbXJZD3p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758588AbXJZD3p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 23:29:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752030AbXJZD3i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 23:29:38 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:60063 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752021AbXJZD3i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 23:29:38 -0400
Date: Thu, 25 Oct 2007 19:54:07 -0700
From: Greg KH <greg@kroah.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Robert Hancock <hancockr@shaw.ca>, akpm@linux-foundation.org, ak@suse.de,
       rajesh.shah@intel.com, torvalds@linux-foundation.org,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: - mmconfig-validate-against-acpi-motherboard-resources.patch
	removed from -mm tree
Message-ID: <20071026025407.GA21408@kroah.com>
References: <200708151919.l7FJJfUE010966@imap1.linux-foundation.org> <472124C1.6090701@shaw.ca> <200710251622.36773.jbarnes@virtuousgeek.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200710251622.36773.jbarnes@virtuousgeek.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 25, 2007 at 04:22:35PM -0700, Jesse Barnes wrote:
> I think Greg doesn't like it, even though we don't have an alternative 
> at this point...

Yes, I didn't like it, Ivan didn't like it, and I got reports that it
wasn't even needed at all once you upgraded your BIOS to the latest
version.

So, is this still needed?  And if so, can you try to implement what Ivan
suggested to do here instead?

thanks,

greg k-h
