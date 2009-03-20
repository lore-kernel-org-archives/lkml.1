Return-Path: <linux-kernel-owner+w=401wt.eu-S1759264AbZCTLQf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759264AbZCTLQf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 07:16:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753399AbZCTLQB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 07:16:01 -0400
Received: from casper.infradead.org ([85.118.1.10]:36279 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751622AbZCTLP7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 07:15:59 -0400
Subject: Re: [PATCH v3 0/6] ATS capability support for Intel IOMMU
From: David Woodhouse <dwmw2@infradead.org>
To: "Zhao, Yu" <yu.zhao@intel.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <49C303B5.5040707@intel.com>
References: <1234443038-15437-1-git-send-email-yu.zhao@intel.com>
	 <20090319193043.583ad601@hobbes.lan>  <49C303B5.5040707@intel.com>
Content-Type: text/plain
Date: Fri, 20 Mar 2009 11:15:51 +0000
Message-Id: <1237547751.16570.27.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-03-20 at 10:47 +0800, Zhao, Yu wrote:
> If it's possible, I'd like it go through the PCI tree because the ATS 
> depends on the SR-IOV. This dependency is not reflected in this v3 
> series since the SR-IOV is not in-tree and I don't want to break the 
> build after people apply the ATS on their tree.

In what way will it depend on SR-IOV?

> So Dave, can I get an ack from you and let Jesse pull the IOMMU change
> to his tree? Or let this ATS go to 2.6.31?

Want to show the latest version of the patches which depend on SR-IOV,
and I can ack them?

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

