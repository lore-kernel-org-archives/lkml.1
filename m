Return-Path: <linux-kernel-owner+w=401wt.eu-S1759843AbZJGSOu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759843AbZJGSOu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 14:14:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759726AbZJGSOt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 14:14:49 -0400
Received: from mail.gmx.net ([213.165.64.20]:43414 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756579AbZJGSOt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 14:14:49 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+E27YfHLCEH3oy918VN/yXK/AXzGelL31dOILsKg
	5Uy+inA14GyJPQ
Subject: Re: Linux 2.6.32-rc3
From: Mike Galbraith <efault@gmx.de>
To: david@lang.hm
Cc: Theodore Tso <tytso@mit.edu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Dave Airlie <airlied@gmail.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Dirk Hohndel <hohndel@infradead.org>, Len Brown <lenb@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.00.0910071040560.11706@asgard.lang.hm>
References: <alpine.LFD.2.01.0910041727310.3432@localhost.localdomain>
	 <alpine.LFD.2.00.0910052140100.309@localhost.localdomain>
	 <1254797502.14122.146.camel@dhohndel-mobl.amr.corp.intel.com>
	 <alpine.LFD.2.01.0910060705240.3432@localhost.localdomain>
	 <1254864803.6035.25.camel@pasglop>
	 <alpine.LFD.2.01.0910061513510.3432@localhost.localdomain>
	 <21d7e9970910061822i429344amb47b0bceb552abc6@mail.gmail.com>
	 <alpine.LFD.2.01.0910062015200.3432@localhost.localdomain>
	 <alpine.LFD.2.01.0910062025300.3432@localhost.localdomain>
	 <20091007135233.GK17883@mit.edu>
	 <1254927134.7121.36.camel@marge.simson.net>
	 <alpine.DEB.2.00.0910071040560.11706@asgard.lang.hm>
Content-Type: text/plain
Date: Wed, 07 Oct 2009 20:13:48 +0200
Message-Id: <1254939228.7523.12.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.68
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-10-07 at 10:44 -0700, david@lang.hm wrote:

> as I understand it, if you only use the released kernel then 
> CONFIG_LOCALVERSION_AUTO will make no difference to you.
> 
> the kernel string only changes if you use a non-release kernel.

Oh no, I pull/build multiple trees daily.

	-Mike

