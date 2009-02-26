Return-Path: <linux-kernel-owner+w=401wt.eu-S1758471AbZBZWlH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758471AbZBZWlH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 17:41:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755989AbZBZWkR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 17:40:17 -0500
Received: from mga14.intel.com ([143.182.124.37]:13323 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755714AbZBZWkQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 17:40:16 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,273,1233561600"; 
   d="scan'208";a="114859254"
From: Jesse Barnes <jesse.barnes@intel.com>
To: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [git pull] PCI fixes
Date: Thu, 26 Feb 2009 14:39:54 -0800
User-Agent: KMail/1.11.0 (Linux/2.6.27-11-generic; KDE/4.2.0; x86_64; ; )
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
References: <200902261424.28906.jesse.barnes@intel.com> <20090226223602.GH16891@parisc-linux.org>
In-Reply-To: <20090226223602.GH16891@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902261439.55260.jesse.barnes@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, February 26, 2009 2:36:03 pm Matthew Wilcox wrote:
> On Thu, Feb 26, 2009 at 02:24:28PM -0800, Jesse Barnes wrote:
> > Matthew Wilcox (1):
> >       PCI/MSI: fix msi_mask() shift fix
>
> This one already appears to be in Linus' tree ... did you drive git
> request-pull badly?

No I just haven't merged his tree since then.  But then no one else should be 
touching these PCI bits, right? :)

-- 
Jesse Barnes, Intel Open Source Technology Center
