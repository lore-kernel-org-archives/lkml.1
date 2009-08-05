Return-Path: <linux-kernel-owner+w=401wt.eu-S964825AbZHERIr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964825AbZHERIr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 13:08:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934483AbZHERIq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 13:08:46 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:39210 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934462AbZHERIq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 13:08:46 -0400
Subject: Re: 2.6.31-rc1: zaurus suspend regressing
From: David Woodhouse <dwmw2@infradead.org>
To: Daniel Mack <daniel@caiaq.de>
Cc: Eric Miao <eric.y.miao@gmail.com>, - Cortez - <omegamoon@gmail.com>,
       Pavel Machek <pavel@ucw.cz>, rpurdie@rpsys.net, lenz@cs.wisc.edu,
       kernel list <linux-kernel@vger.kernel.org>, Dirk@opfer-online.de,
       arminlitzel@web.de, Cyril Hrubis <metan@ucw.cz>, thommycheck@gmail.com,
       linux-arm-kernel@jasper.es
In-Reply-To: <20090805163036.GJ13236@buzzloop.caiaq.de>
References: <20090704024416.GA1345@ucw.cz> <20090715002445.GB2360@ucw.cz>
	 <1f96a3530907200711h1e08bfb5k7123491cf688d9b1@mail.gmail.com>
	 <4A64823C.2040601@gmail.com>
	 <1f96a3530907201350n209483a5va803235536d241d0@mail.gmail.com>
	 <4A651A8E.5070407@gmail.com>  <20090805163036.GJ13236@buzzloop.caiaq.de>
Content-Type: text/plain
Date: Wed, 05 Aug 2009 18:08:33 +0100
Message-Id: <1249492113.9324.369.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-08-05 at 18:30 +0200, Daniel Mack wrote:
> 
> That bug hit me as well, and as in Cortez' case, reverting 15bce40
> fixed
> it for me on a PXA3xx platform.

Can you confirm that the fix in the mtd-2.6.git tree is sufficient?

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

