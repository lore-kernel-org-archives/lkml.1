Return-Path: <linux-kernel-owner+w=401wt.eu-S1757724AbZBKRlT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757724AbZBKRlT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 12:41:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754884AbZBKRlI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 12:41:08 -0500
Received: from outbound-mail-25.bluehost.com ([69.89.21.20]:46082 "HELO
	outbound-mail-25.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754701AbZBKRlH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 12:41:07 -0500
X-Greylist: delayed 439 seconds by postgrey-1.27 at vger.kernel.org; Wed, 11 Feb 2009 12:41:07 EST
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=osMnIQkgkOkdWfMUifPL8tvtWW3z8KVBydUg1EQr2G1AqTVIy0BLS0BUvcgxbRmqgNQ28LDhC1Tz4CIpoNQnZfCuwfiyPHfDVZFfvN0si1Z73/c1TtF3y6WVHruMh/9l;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH v2 1/6] PCI: support the ATS capability
Date: Wed, 11 Feb 2009 09:33:44 -0800
User-Agent: KMail/1.9.10
Cc: Yu Zhao <yu.zhao@intel.com>, linux-pci@vger.kernel.org,
       iommu@lists.linux-foundation.org, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <1232252254-7614-1-git-send-email-yu.zhao@intel.com> <1232252254-7614-2-git-send-email-yu.zhao@intel.com> <1234265550.10484.62.camel@macbook.infradead.org>
In-Reply-To: <1234265550.10484.62.camel@macbook.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902110933.44861.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, February 10, 2009 3:32 am David Woodhouse wrote:
> On Sun, 2009-01-18 at 12:17 +0800, Yu Zhao wrote:
> > The ATS spec can be found at
> > http://www.pcisig.com/specifications/iov/ats/ (it requires membership).
> >
> > Signed-off-by: Yu Zhao <yu.zhao@intel.com>
>
> If I can have an ack from Jesse for the PCI bits (which is basically
> this patch), I'll take the whole lot through my iommu tree. OK?

Yep, looks fine.

Acked-by: Jesse Barnes <jbarnes@virtuousgeek.org>

-- 
Jesse Barnes, Intel Open Source Technology Center
