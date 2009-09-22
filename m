Return-Path: <linux-kernel-owner+w=401wt.eu-S1753467AbZIVXoN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753467AbZIVXoN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 19:44:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753291AbZIVXoM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 19:44:12 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:55814 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753255AbZIVXoM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 19:44:12 -0400
Subject: Re: [PATCH 2/6] mtd: m25p80: Convert to device table matching
From: David Woodhouse <dwmw2@infradead.org>
To: avorontsov@ru.mvista.com
Cc: Andrew Morton <akpm@linux-foundation.org>,
       David Brownell <david-b@pacbell.net>, ben@fluff.org,
       grant.likely@secretlab.ca, benh@kernel.crashing.org, khali@linux-fr.org,
       linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
       lm-sensors@lm-sensors.org, linuxppc-dev@ozlabs.org
In-Reply-To: <20090922230150.GA27593@oksana.dev.rtsoft.ru>
References: <20090731003957.GA23982@oksana.dev.rtsoft.ru>
	 <20090731004100.GB8371@oksana.dev.rtsoft.ru>
	 <200908031954.50955.david-b@pacbell.net>
	 <20090922141705.b5d31e24.akpm@linux-foundation.org>
	 <20090922230150.GA27593@oksana.dev.rtsoft.ru>
Content-Type: text/plain
Date: Tue, 22 Sep 2009 16:43:47 -0700
Message-Id: <1253663027.27055.528.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-09-23 at 03:01 +0400, Anton Vorontsov wrote:
> 
> And the two patches I sent on top:
> 
> http://lkml.org/lkml/2009/8/18/364
> http://lkml.org/lkml/2009/8/18/366

Got versions of those which apply to the mtd-2.6.git tree (which I'm
about to ask Linus to pull)? 

-- 
dwmw2

