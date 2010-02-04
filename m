Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757949Ab0BDAFN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 19:05:13 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49863 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756869Ab0BDAFH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 19:05:07 -0500
Date: Wed, 3 Feb 2010 16:04:07 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>, Tony Luck <tony.luck@intel.com>,
       linux-pci@vger.kernel.org, Peter Haight <peterh@sapros.com>,
       Gary Hade <garyhade@us.ibm.com>, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH v1 0/7] PCI: try enabling "pci=use_crs" again
In-Reply-To: <20100203233617.10803.92102.stgit@bob.kio>
Message-ID: <alpine.LFD.2.00.1002031603190.3707@localhost.localdomain>
References: <20100203233617.10803.92102.stgit@bob.kio>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 3 Feb 2010, Bjorn Helgaas wrote:
> 
> These apply on 0148b041be4e7, which is the current head of the linux-next
> branch of Jesse's pci-2.6 git tree.  The first patch is just Jeff Garrett's
> patch to remove intel_bus.c, so that is only here for people who want to test
> the rest of the patches.  I expect Jesse will pick up Jeff's patch via Linus'
> tree.

All patches look sane to me. Let's get them merged early in the next merge 
window, and hope for the best.

		Linus
