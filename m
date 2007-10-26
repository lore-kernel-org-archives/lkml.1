Return-Path: <linux-kernel-owner+w=401wt.eu-S1753448AbXJZFqn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753448AbXJZFqn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 01:46:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750896AbXJZFqg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 01:46:36 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:48831 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751375AbXJZFqf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 01:46:35 -0400
Date: Thu, 25 Oct 2007 22:27:54 -0700
From: Greg KH <greg@kroah.com>
To: Robert Hancock <hancockr@shaw.ca>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, akpm@linux-foundation.org,
       ak@suse.de, rajesh.shah@intel.com, torvalds@linux-foundation.org,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: - mmconfig-validate-against-acpi-motherboard-resources.patch
	removed from -mm tree
Message-ID: <20071026052754.GA23116@kroah.com>
References: <200708151919.l7FJJfUE010966@imap1.linux-foundation.org> <472124C1.6090701@shaw.ca> <200710251622.36773.jbarnes@virtuousgeek.org> <20071026025407.GA21408@kroah.com> <47217537.3050905@shaw.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47217537.3050905@shaw.ca>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 25, 2007 at 11:03:51PM -0600, Robert Hancock wrote:
> Greg KH wrote:
>> On Thu, Oct 25, 2007 at 04:22:35PM -0700, Jesse Barnes wrote:
>>> I think Greg doesn't like it, even though we don't have an alternative at 
>>> this point...
>> Yes, I didn't like it, Ivan didn't like it, and I got reports that it
>> wasn't even needed at all once you upgraded your BIOS to the latest
>> version.
>> So, is this still needed?  And if so, can you try to implement what Ivan
>> suggested to do here instead?
>
> Aren't you guys referring to 
> pci-disable-decode-of-io-memory-during-bar-sizing.patch? This is another 
> one entirely, though related.

I have no idea, there have been a lot of conflicting patches in this
area...
