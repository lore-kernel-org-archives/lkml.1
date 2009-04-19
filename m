Return-Path: <linux-kernel-owner+w=401wt.eu-S1754631AbZDSIX0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754631AbZDSIX0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Apr 2009 04:23:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752636AbZDSIXE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Apr 2009 04:23:04 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:55439 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751966AbZDSIXA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Apr 2009 04:23:00 -0400
Date: Sun, 19 Apr 2009 10:22:27 +0200
From: Ingo Molnar <mingo@elte.hu>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Weidong Han <weidong.han@intel.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, allen.m.kay@intel.com,
       fenghua.yu@intel.com, linux-kernel@vger.kernel.org,
       iommu@lists.linux-foundation.org
Subject: Re: [PATCH 0/5] fix bugs of x2apic/intr-remap
Message-ID: <20090419082227.GA24524@elte.hu>
References: <1239957736-6161-1-git-send-email-weidong.han@intel.com> <20090417143033.GF23493@elte.hu> <1240122767.3589.35.camel@macbook.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1240122767.3589.35.camel@macbook.infradead.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* David Woodhouse <dwmw2@infradead.org> wrote:

> On Fri, 2009-04-17 at 16:30 +0200, Ingo Molnar wrote:
> > 
> > I've made a few smaller observations to specific patches but none 
> > seemed like a real showstopper to me so i've applied your series to 
> > tip:x86/apic (with minor edits to the changelogs) to get this tested 
> > some more - pending Ack/Nak from David and Jesse for the IOMMU and 
> > PCI interactions.
> 
> For all five: 
> Acked-by: David Woodhouse <David.Woodhouse@intel.com>

Thanks!

	Ingo
