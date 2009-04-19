Return-Path: <linux-kernel-owner+w=401wt.eu-S1760704AbZDSGdM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760704AbZDSGdM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Apr 2009 02:33:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756322AbZDSGc5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Apr 2009 02:32:57 -0400
Received: from casper.infradead.org ([85.118.1.10]:40106 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755497AbZDSGc5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Apr 2009 02:32:57 -0400
Subject: Re: [PATCH 0/5] fix bugs of x2apic/intr-remap
From: David Woodhouse <dwmw2@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Weidong Han <weidong.han@intel.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, allen.m.kay@intel.com,
       fenghua.yu@intel.com, linux-kernel@vger.kernel.org,
       iommu@lists.linux-foundation.org
In-Reply-To: <20090417143033.GF23493@elte.hu>
References: <1239957736-6161-1-git-send-email-weidong.han@intel.com>
	 <20090417143033.GF23493@elte.hu>
Content-Type: text/plain
Date: Sun, 19 Apr 2009 07:32:47 +0100
Message-Id: <1240122767.3589.35.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 (2.26.1-2.fc11) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-04-17 at 16:30 +0200, Ingo Molnar wrote:
> 
> I've made a few smaller observations to specific patches but none 
> seemed like a real showstopper to me so i've applied your series to 
> tip:x86/apic (with minor edits to the changelogs) to get this tested 
> some more - pending Ack/Nak from David and Jesse for the IOMMU and 
> PCI interactions.

For all five: 
Acked-by: David Woodhouse <David.Woodhouse@intel.com>

-- 
dwmw2

