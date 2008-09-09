Return-Path: <linux-kernel-owner+w=401wt.eu-S1756143AbYIIOat@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756143AbYIIOat (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 10:30:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753735AbYIIOak
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 10:30:40 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:56249 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752838AbYIIOak (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 10:30:40 -0400
Date: Tue, 9 Sep 2008 08:30:39 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Alex Chiang <achiang@hp.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
       jbarnes@virtuousgeek.org, kristen.c.accardi@intel.com,
       kaneshige.kenji@jp.fujitsu.com
Subject: Re: [PATCH v2 03/13] PCI, PCI Hotplug: introduce slot_name helpers
Message-ID: <20080909143038.GX2772@parisc-linux.org>
References: <20080909091813.29542.85613.stgit@bob.kio> <20080909100017.29542.2802.stgit@bob.kio>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080909100017.29542.2802.stgit@bob.kio>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 09, 2008 at 04:00:17AM -0600, Alex Chiang wrote:
> In preparation for cleaning up the various hotplug drivers
> such that they don't have to manage their own 'name' parameters
> anymore, we provide the following convenience functions:
> 
> 	pci_slot_name()
> 	hotplug_slot_name()
> 
> These helpers will be used by individual hotplug drivers.
> 
> Cc: jbarnes@virtuousgeek.org
> Cc: kristen.c.accardi@intel.com
> Cc: matthew@wil.cx
> Cc: kaneshige.kenji@jp.fujitsu.com
> Signed-off-by: Alex Chiang <achiang@hp.com>

Acked-by: Matthew Wilcox <willy@linux.intel.com>

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
