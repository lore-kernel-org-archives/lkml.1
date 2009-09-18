Return-Path: <linux-kernel-owner+w=401wt.eu-S1752866AbZIROdn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752866AbZIROdn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 10:33:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752217AbZIROdm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 10:33:42 -0400
Received: from one.firstfloor.org ([213.235.205.2]:44563 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751893AbZIROdl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 10:33:41 -0400
Date: Fri, 18 Sep 2009 16:33:41 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Cc: Andi Kleen <andi@firstfloor.org>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: aim7 scalability issue on 4 socket machine
Message-ID: <20090918143341.GG17634@basil.fritz.box>
References: <1253179879.2606.37.camel@ymzhang> <1253180411.8497.1.camel@twins> <Pine.LNX.4.64.0909171122180.25864@sister.anvils> <1253239339.2606.40.camel@ymzhang> <20090917195909.3a00ef83.akpm@linux-foundation.org> <Pine.LNX.4.64.0909180742500.14561@sister.anvils> <20090918071217.GB17634@basil.fritz.box> <1253279702.4732.24.camel@useless.americas.hpqcorp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1253279702.4732.24.camel@useless.americas.hpqcorp.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > 
> > AFAIK Lee usually tests on large IA64 boxes.
> 
> In this case, it's an x86_64 [DL785] platform--an 8 socket, 4 core
> Shanghai in a glueless, "twisted ladder" config.

Thanks for the correction. However it's still a quite different system,
so I think it's clear it happens on multiple different systems.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
