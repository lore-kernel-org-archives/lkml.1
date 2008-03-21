Return-Path: <linux-kernel-owner+w=401wt.eu-S1758178AbYCUTah@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758178AbYCUTah (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 15:30:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752606AbYCUTa1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 15:30:27 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:47916 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751078AbYCUTa0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 15:30:26 -0400
Date: Fri, 21 Mar 2008 13:30:09 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
Cc: Alex Chiang <achiang@hp.com>, Greg KH <gregkh@suse.de>,
       Gary Hade <garyhade@us.ibm.com>,
       Kristen Carlson Accardi <kristen.c.accardi@intel.com>,
       warthog19@eaglescrag.net, rick.jones2@hp.com,
       linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz,
       linux-acpi@vger.kernel.org
Subject: Re: [PATCH  9/16] PCI slot: Remove unused slot member from pci_dev (Not for mainline!)
Message-ID: <20080321193009.GI424@parisc-linux.org>
References: <20080318210539.GA30421@ldl.fc.hp.com> <47E33472.1000602@jp.fujitsu.com> <47E33693.7080102@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47E33693.7080102@jp.fujitsu.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 21, 2008 at 01:16:19PM +0900, Kenji Kaneshige wrote:
> The 'slot' member in struct pci_dev is not used. Remove this unused
> member.

It *ought* to be used.  If it isn't yet, I guess that part of my patch
has been dropped, and it should be re-added.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
