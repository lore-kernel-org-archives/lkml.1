Return-Path: <linux-kernel-owner+w=401wt.eu-S1757974AbZC2Nvq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757974AbZC2Nvq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Mar 2009 09:51:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755850AbZC2Nvf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Mar 2009 09:51:35 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:36391 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755447AbZC2Nve (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Mar 2009 09:51:34 -0400
Date: Sun, 29 Mar 2009 07:51:31 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Yu Zhao <yu.zhao@intel.com>, dwmw2@infradead.org,
       linux-pci@vger.kernel.org, iommu@lists.linux-foundation.org,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 0/6] PCI: support the ATS capability
Message-ID: <20090329135131.GS8014@parisc-linux.org>
References: <1237795142-6606-1-git-send-email-yu.zhao@intel.com> <20090326161556.05cdd801@hobbes>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090326161556.05cdd801@hobbes>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 26, 2009 at 04:15:56PM -0700, Jesse Barnes wrote:
> >   2, avoid using pci_find_ext_capability every time when reading ATS
> >      Invalidate Queue Depth (Matthew Wilcox)

I asked a question about how that was used, and got back a version which
changed how it was done.  I still don't have an answer to my question.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
