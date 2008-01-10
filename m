Return-Path: <linux-kernel-owner+w=401wt.eu-S1757895AbYAJTnV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757895AbYAJTnV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 14:43:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755028AbYAJTnI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 14:43:08 -0500
Received: from mail.suse.de ([195.135.220.2]:55903 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755950AbYAJTnF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 14:43:05 -0500
Date: Thu, 10 Jan 2008 11:43:06 -0800
From: Greg KH <gregkh@suse.de>
To: venkatesh.pallipadi@intel.com
Cc: ak@muc.de, ebiederm@xmission.com, rdreier@cisco.com,
       torvalds@linux-foundation.org, airlied@skynet.ie, davej@redhat.com,
       mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
       akpm@linux-foundation.org, arjan@infradead.org, jesse.barnes@intel.com,
       davem@davemloft.net, linux-kernel@vger.kernel.org,
       Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: [patch 11/11] PAT x86: Expose uc and wc interfaces in /sysfs
	vor pci_mmap_resource
Message-ID: <20080110194306.GA21357@suse.de>
References: <20080110184840.927409000@intel.com> <20080110184856.859264000@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080110184856.859264000@intel.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 10, 2008 at 10:48:51AM -0800, venkatesh.pallipadi@intel.com wrote:
> New interfaces exported for uc and wc accesses. Apps has to change to use
> these new interfaces.
> 
> Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
> Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>

Please update the documentation for this change, as well as adding
something to Documentation/ABI/ for these new sysfs files.

thanks,

greg k-h
