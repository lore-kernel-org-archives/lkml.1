Return-Path: <linux-kernel-owner+w=401wt.eu-S1754518AbYHSPF3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754518AbYHSPF3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 11:05:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752849AbYHSPFU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 11:05:20 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:33778 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752807AbYHSPFT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 11:05:19 -0400
Date: Tue, 19 Aug 2008 09:05:03 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Adrian Bunk <bunk@kernel.org>
Cc: gerg@uclinux.org, jbarnes@virtuousgeek.org, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org
Subject: Re: [2.6 patch] m68knommu: let PCI depend on BROKEN
Message-ID: <20080819150502.GA8318@parisc-linux.org>
References: <20080819134718.GH8852@cs181140183.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080819134718.GH8852@cs181140183.pp.htv.fi>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 19, 2008 at 04:47:18PM +0300, Adrian Bunk wrote:
> There exists blackfin hardware with PCI support, but the support
               ^^^^^^^^
m68knommu
> currently in the kernel fails to build starting with:

Hopefully someone fixes it instead of just acking this patch.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
