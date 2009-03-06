Return-Path: <linux-kernel-owner+w=401wt.eu-S1756982AbZCFTd7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756982AbZCFTd7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 14:33:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753555AbZCFTds
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 14:33:48 -0500
Received: from palinux.external.hp.com ([192.25.206.14]:37737 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751221AbZCFTdr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 14:33:47 -0500
Date: Fri, 6 Mar 2009 12:33:30 -0700
From: Matthew Wilcox <matthew@wil.cx>
To: Avi Kivity <avi@redhat.com>
Cc: Yu Zhao <yu.zhao@intel.com>, jbarnes@virtuousgeek.org,
       linux-pci@vger.kernel.org, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH v10 0/7] PCI: Linux kernel SR-IOV support
Message-ID: <20090306193329.GB25995@parisc-linux.org>
References: <1235112888-9524-1-git-send-email-yu.zhao@intel.com> <49A3D04A.9010501@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49A3D04A.9010501@redhat.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 24, 2009 at 12:47:38PM +0200, Avi Kivity wrote:
> Do those patches allow using a VF on the host (in other words, does the 
> kernel emulate config space accesses)?

SR-IOV hardware handles config space accesses to virtual functions.  No
kernel changes needed for that aspect of it.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
