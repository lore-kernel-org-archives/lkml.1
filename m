Return-Path: <linux-kernel-owner+w=401wt.eu-S965965AbYD1RET@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965965AbYD1RET (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 13:04:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935113AbYD1RD4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 13:03:56 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:59358 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933780AbYD1RDz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 13:03:55 -0400
Date: Mon, 28 Apr 2008 11:03:39 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Matti Linnanvuori <mattilinnanvuori@yahoo.com>
Cc: jbarnes@virtuousgeek.org, linux-kernel@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz, willy@linux.intel.com
Subject: Re: [patch] doc: fix an incorrect suggestion to pass NULL for PCI like buses
Message-ID: <20080428170338.GV14990@parisc-linux.org>
References: <392740.53131.qm@web52007.mail.re2.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <392740.53131.qm@web52007.mail.re2.yahoo.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 28, 2008 at 09:33:27AM -0700, Matti Linnanvuori wrote:
> From: Matti Linnanvuori <mattilinnanvuori@yahoo.com>
> 
> Fix an incorrect suggestion to pass NULL to pci_alloc_consistent
> for PCI like buses where devices don't have struct pci_dev (like ISA, EISA).
> 
> Signed-off-by: Matti Linnanvuori <mattilinnanvuori@yahoo.com>

Acked-by: Matthew Wilcox <willy@linux.intel.com>

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
