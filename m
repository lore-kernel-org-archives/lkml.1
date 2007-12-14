Return-Path: <linux-kernel-owner+w=401wt.eu-S1764810AbXLNKTc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764810AbXLNKTc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 05:19:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750889AbXLNKTY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 05:19:24 -0500
Received: from colin.muc.de ([193.149.48.1]:2625 "EHLO mail.muc.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753367AbXLNKTX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 05:19:23 -0500
Date: 14 Dec 2007 11:19:20 +0100
Date: Fri, 14 Dec 2007 11:19:20 +0100
From: Andi Kleen <ak@muc.de>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Greg KH <gregkh@suse.de>, venkatesh.pallipadi@intel.com, rdreier@cisco.com,
       torvalds@linux-foundation.org, airlied@skynet.ie, davej@redhat.com,
       mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
       akpm@linux-foundation.org, arjan@infradead.org, jesse.barnes@intel.com,
       linux-kernel@vger.kernel.org, Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: [RFC PATCH 08/12] PAT 64b: coherent mmap and sysfs bin ioctl
Message-ID: <20071214101920.GA9705@muc.de>
References: <20071213235543.568682000@intel.com> <20071213235712.813201000@intel.com> <m18x3yq633.fsf@ebiederm.dsl.xmission.com> <20071214060203.GA10100@suse.de> <m1k5nhq0be.fsf@ebiederm.dsl.xmission.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1k5nhq0be.fsf@ebiederm.dsl.xmission.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The obvious thing to do would be to hook it up like:
> drivers/pci/proc.c:proc_bus_pci_ioctl.

Yes that is what it intended to do -- i just had never finished/tested
that.

-Andi
