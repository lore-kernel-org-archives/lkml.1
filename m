Return-Path: <linux-kernel-owner+w=401wt.eu-S1750856AbZISRH3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750856AbZISRH3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Sep 2009 13:07:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750748AbZISRH2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Sep 2009 13:07:28 -0400
Received: from casper.infradead.org ([85.118.1.10]:41663 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750702AbZISRH2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Sep 2009 13:07:28 -0400
Subject: Re: [PATCH] IR: Disallow interrupt remapping if not all ioapic
 under interrupt remapping
From: David Woodhouse <dwmw2@infradead.org>
To: "Youquan,Song" <youquan.song@linux.intel.com>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>,
       "Song, Youquan" <youquan.song@intel.com>,
       "mingo@elte.hu" <mingo@elte.hu>, "hpa@zytor.com" <hpa@zytor.com>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20090920003737.GB21419@youquan-linux.bj.intel.com>
References: <20090907145807.GA30942@youquan-linux.bj.intel.com>
	 <1252532575.2767.32.camel@sbs-t61.sc.intel.com>
	 <20090920003737.GB21419@youquan-linux.bj.intel.com>
Content-Type: text/plain
Date: Sat, 19 Sep 2009 10:07:01 -0700
Message-Id: <1253380022.6317.16.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-09-19 at 20:37 -0400, Youquan,Song wrote:
> Change the patch title to short one.
> David, Couly you please also pick this up? Sorry, if you have done.

http://git.infradead.org/iommu-2.6.git?commit=e936d0773df

I changed the title when I committed it.

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

