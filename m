Return-Path: <linux-kernel-owner+w=401wt.eu-S1758485AbXJZFC5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758485AbXJZFC5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 01:02:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751933AbXJZFCu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 01:02:50 -0400
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:15016 "EHLO
	pd3mo1so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751684AbXJZFCt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 01:02:49 -0400
Date: Thu, 25 Oct 2007 23:03:51 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: - mmconfig-validate-against-acpi-motherboard-resources.patch
 removed from -mm tree
In-reply-to: <20071026025407.GA21408@kroah.com>
To: Greg KH <greg@kroah.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, akpm@linux-foundation.org,
       ak@suse.de, rajesh.shah@intel.com, torvalds@linux-foundation.org,
       linux-kernel <linux-kernel@vger.kernel.org>
Message-id: <47217537.3050905@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <200708151919.l7FJJfUE010966@imap1.linux-foundation.org>
 <472124C1.6090701@shaw.ca> <200710251622.36773.jbarnes@virtuousgeek.org>
 <20071026025407.GA21408@kroah.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> On Thu, Oct 25, 2007 at 04:22:35PM -0700, Jesse Barnes wrote:
>> I think Greg doesn't like it, even though we don't have an alternative 
>> at this point...
> 
> Yes, I didn't like it, Ivan didn't like it, and I got reports that it
> wasn't even needed at all once you upgraded your BIOS to the latest
> version.
> 
> So, is this still needed?  And if so, can you try to implement what Ivan
> suggested to do here instead?

Aren't you guys referring to 
pci-disable-decode-of-io-memory-during-bar-sizing.patch? This is another 
one entirely, though related.
