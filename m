Return-Path: <linux-kernel-owner+w=401wt.eu-S1753074AbZCHPBX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753074AbZCHPBX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Mar 2009 11:01:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752479AbZCHPBM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Mar 2009 11:01:12 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:50483 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752176AbZCHPBL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Mar 2009 11:01:11 -0400
Date: Sun, 8 Mar 2009 09:01:09 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Avi Kivity <avi@redhat.com>
Cc: Yu Zhao <yu.zhao@intel.com>, jbarnes@virtuousgeek.org,
       linux-pci@vger.kernel.org, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, "Yang, Sheng" <sheng.yang@intel.com>
Subject: Re: [PATCH v10 0/7] PCI: Linux kernel SR-IOV support
Message-ID: <20090308150109.GM25995@parisc-linux.org>
References: <1235112888-9524-1-git-send-email-yu.zhao@intel.com> <49A3D04A.9010501@redhat.com> <20090306193329.GB25995@parisc-linux.org> <49B3D678.4050004@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49B3D678.4050004@redhat.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 08, 2009 at 04:30:16PM +0200, Avi Kivity wrote:
> Matthew Wilcox wrote:
> >On Tue, Feb 24, 2009 at 12:47:38PM +0200, Avi Kivity wrote:
> >>Do those patches allow using a VF on the host (in other words, does the 
> >>kernel emulate config space accesses)?
> >
> >SR-IOV hardware handles config space accesses to virtual functions.  No
> >kernel changes needed for that aspect of it.
> 
> Patches 2 and 3 of the patchset that enables SR/IOV in kvm [1] suggest 
> that at the config space is only partially implemented.
> 
> [1] http://thread.gmane.org/gmane.comp.emulators.kvm.devel/29034

I believe Red Hat are now members of the PCI SIG, you really should
download the SR-IOV spec that Yu Zhao keeps pointing at.  It's going to
be very hard to have a sensible discussion if you haven't read it.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
