Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1753358AbYLQCiQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753358AbYLQCiQ (ORCPT <rfc822;akpm@linux-foundation.org>);
	Tue, 16 Dec 2008 21:38:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752595AbYLQCh5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 21:37:57 -0500
Received: from sineb-mail-1.sun.com ([192.18.19.6]:39039 "EHLO
	sineb-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752529AbYLQCh4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 21:37:56 -0500
Date: Wed, 17 Dec 2008 10:37:54 +0800
From: Jike Song <albcamus@gmail.com>
Subject: Re: [PATCH 0/13 v7] PCI: Linux kernel SR-IOV support
In-reply-to: <200812161523.55238.jbarnes@virtuousgeek.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Yu Zhao <yu.zhao@intel.com>, linux-pci@vger.kernel.org, achiang@hp.com,
        bjorn.helgaas@hp.com, grundler@parisc-linux.org, greg@kroah.com,
        mingo@elte.hu, matthew@wil.cx, randy.dunlap@oracle.com,
        rdreier@cisco.com, horms@verge.net.au, yinghai@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Message-id: <49486602.5000108@gmail.com>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7BIT
References: <20081121183605.GA7810@yzhao12-linux.sh.intel.com>
 <200812161523.55238.jbarnes@virtuousgeek.org>
User-Agent: Thunderbird 2.0.0.18 (X11/20081105)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jesse Barnes wrote:
> Given a respin of 10-13 I think it's reasonable to merge this into 2.6.29, but 
> I'd be much happier about it if we got some driver code along with it, so as 
> not to have an unused interface sitting around for who knows how many 
> releases.  Is that reasonable?  Do you know if any of the corresponding PF/VF 
> driver bits are ready yet?

Hi Jesse, 

Yu Zhao has posted a patch set with subject "SR-IOV driver example" 
at November 26, which illustrated the usage of SR-IOV API in Intel 82576 VF/PF
drivers;-)

--
Thanks,
Jike
