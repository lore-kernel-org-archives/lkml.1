Return-Path: <linux-kernel-owner+w=401wt.eu-S1752449AbZC2FVc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752449AbZC2FVc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Mar 2009 01:21:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751009AbZC2FVV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Mar 2009 01:21:21 -0400
Received: from colo.lackof.org ([198.49.126.79]:54444 "EHLO colo.lackof.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750896AbZC2FVU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Mar 2009 01:21:20 -0400
Date: Sat, 28 Mar 2009 23:21:07 -0600
From: Grant Grundler <grundler@parisc-linux.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Yu Zhao <yu.zhao@intel.com>, dwmw2@infradead.org,
       linux-pci@vger.kernel.org, iommu@lists.linux-foundation.org,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 0/6] PCI: support the ATS capability
Message-ID: <20090329052107.GC19602@colo.lackof.org>
References: <1237795142-6606-1-git-send-email-yu.zhao@intel.com> <20090326161556.05cdd801@hobbes>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090326161556.05cdd801@hobbes>
X-Home-Page: http://www.parisc-linux.org/
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 26, 2009 at 04:15:56PM -0700, Jesse Barnes wrote:
...
> This is a good sized chunk of new code, and you want it to come through
> the PCI tree, right?  It looks like it's seen some review from Grant,
> David and Matthew but I don't see any Reviewed-by or Acked-by tags in
> there... Anyone willing to provide those?

Sorry, I'm not. I've read through the code but don't understand the
many of the details about how this particular HW works. All I can
do is pick nits.

cheers,
grant
