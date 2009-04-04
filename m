Return-Path: <linux-kernel-owner+w=401wt.eu-S1762446AbZDDJqt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762446AbZDDJqt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Apr 2009 05:46:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757026AbZDDJqk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Apr 2009 05:46:40 -0400
Received: from casper.infradead.org ([85.118.1.10]:60118 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756267AbZDDJqk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Apr 2009 05:46:40 -0400
Subject: RE: [patch 2/2] x2apic/intr-remap: decouple interrupt remapping
 from x2apic
From: David Woodhouse <dwmw2@infradead.org>
To: "Han, Weidong" <weidong.han@intel.com>
Cc: "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       "'Ingo Molnar'" <mingo@elte.hu>,
       "'IOMMU'" <iommu@lists.linux-foundation.org>,
       "'LKML'" <linux-kernel@vger.kernel.org>
In-Reply-To: <715D42877B251141A38726ABF5CABF2C01A2F7C442@pdsmsx503.ccr.corp.intel.com>
References: <715D42877B251141A38726ABF5CABF2C01A2F7C3A7@pdsmsx503.ccr.corp.intel.com>
	 <1238781474.27006.7866.camel@localhost.localdomain>
	 <715D42877B251141A38726ABF5CABF2C01A2F7C435@pdsmsx503.ccr.corp.intel.com>
	 <1238833738.3560.14.camel@macbook.infradead.org>
	 <715D42877B251141A38726ABF5CABF2C01A2F7C440@pdsmsx503.ccr.corp.intel.com>
	 <1238836040.3560.17.camel@macbook.infradead.org>
	 <1238836532.3560.19.camel@macbook.infradead.org>
	 <715D42877B251141A38726ABF5CABF2C01A2F7C442@pdsmsx503.ccr.corp.intel.com>
Content-Type: text/plain
Date: Sat, 04 Apr 2009 10:46:25 +0100
Message-Id: <1238838385.3560.20.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.0 (2.26.0-1.fc11) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-04-04 at 17:21 +0800, Han, Weidong wrote:
> Following patch fixes it. I tested it with different combinations, it
> works fine for me. pls try on your side. 

Works without x2apic; just about to test with it. Thanks.

-- 
dwmw2

