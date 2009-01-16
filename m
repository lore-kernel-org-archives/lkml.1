Return-Path: <linux-kernel-owner+w=401wt.eu-S936902AbZAPSiY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936902AbZAPSiY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 13:38:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760795AbZAPShb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 13:37:31 -0500
Received: from outbound-mail-154.bluehost.com ([67.222.39.34]:42664 "HELO
	outbound-mail-154.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S936646AbZAPSh2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 13:37:28 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=Bd7Fd3R6DmWER3XKjjY0G2pQn3zGzYCTAdAHkvf+W2PCXmT27MSdK97XkLeZyOh78BXpmM2TE91/YLR4RRUaOOsXxxgoOUUaprC4MuYaXr5bq5p8Kn4TAgb719jJ5kmp;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Yu Zhao <yu.zhao@intel.com>
Subject: Re: [PATCH 1/6] PCI: support the ATS capability
Date: Fri, 16 Jan 2009 10:37:23 -0800
User-Agent: KMail/1.9.10
Cc: "dwmw2@infradead.org" <dwmw2@infradead.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20090107144716.GA4697@yzhao12-linux.sh.intel.com> <20090107145224.GB4697@yzhao12-linux.sh.intel.com>
In-Reply-To: <20090107145224.GB4697@yzhao12-linux.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901161037.23625.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, January 7, 2009 6:52 am Yu Zhao wrote:
> The ATS spec can be found at http://www.pcisig.com/specifications/iov/ats/
> (it requires membership).
>
> Signed-off-by: Yu Zhao <yu.zhao@intel.com>

Can you respin this against my linux-next branch so I can apply it?  I'll let 
David take the other bits.

Thanks,
-- 
Jesse Barnes, Intel Open Source Technology Center
