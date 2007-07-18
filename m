Return-Path: <linux-kernel-owner+w=401wt.eu-S936993AbXGRAlg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936993AbXGRAlg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 20:41:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761053AbXGRAlZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 20:41:25 -0400
Received: from gw.goop.org ([64.81.55.164]:46152 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759934AbXGRAlX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 20:41:23 -0400
Message-ID: <469D617B.6000801@goop.org>
Date: Tue, 17 Jul 2007 17:40:27 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.4 (X11/20070615)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Stephen Hemminger <shemminger@linux-foundation.org>,
       Jeremy Fitzhardinge <jeremy@xensource.com>,
       Linus Torvalds <torvalds@linux-foundation.com>, Andi Kleen <ak@suse.de>,
       Andrew Morton <akpm@linux-foundation.com>,
       lkml <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Chris Wright <chrisw@sous-sol.org>, Ian Pratt <ian.pratt@xensource.com>,
       Christian Limpach <Christian.Limpach@cl.cam.ac.uk>,
       Jeff Garzik <jeff@garzik.org>, Christoph Hellwig <hch@infradead.org>,
       Herbert Xu <herbert@gondor.apana.org.au>,
       Keir Fraser <Keir.Fraser@cl.cam.ac.uk>, netdev@vger.kernel.org
Subject: Re: [patch 37/44] xen: add virtual network device driver
References: <20070716231536.937393000@xensource.com>	 <20070716232916.472694000@xensource.com> <20070717094511.795beb69@oldman>	 <469CD222.1030202@goop.org> <1184715909.10380.39.camel@localhost.localdomain>
In-Reply-To: <1184715909.10380.39.camel@localhost.localdomain>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell wrote:
> The default function points to the internal stats...
>   

Right you are.

    J
