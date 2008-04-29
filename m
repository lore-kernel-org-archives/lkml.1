Return-Path: <linux-kernel-owner+w=401wt.eu-S1757222AbYD2SAu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757222AbYD2SAu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 14:00:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753331AbYD2SAk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 14:00:40 -0400
Received: from outbound-mail-111.bluehost.com ([69.89.18.7]:35775 "HELO
	outbound-mail-111.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753480AbYD2SAk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 14:00:40 -0400
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: PCI tree info
Date: Tue, 29 Apr 2008 11:00:08 -0700
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz,
       Kristen Carlson Accardi <kristen.c.accardi@intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804291100.08622.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The PCI tree now lives in git:  
git://git.kernel.org/pub/scm/linux/kernel/git/jbarnes/pci-2.6.  There are a 
few branches:
  for-linus - stuff headed to Linus in the next pull request
  linux-next - patches targetted at the following release
  master - unmodified Linus upstream branch

I'll try to avoid re-basing, but since the main downstream tree is the PCI 
hotplug tree, and Kristen uses quilt, that probably won't be much of an 
issue.

If we end up with some big patchsets (like the resource management unification 
benh has been talking about) needing a lot of testing, I may create a 'test' 
or 'all' branch for akpm and others, but I'll keep everyone posted in that 
case.

Thanks,
Jesse
