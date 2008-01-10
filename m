Return-Path: <linux-kernel-owner+w=401wt.eu-S1756982AbYAJMsc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756982AbYAJMsc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 07:48:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754511AbYAJMsY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 07:48:24 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:53661 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754098AbYAJMsY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 07:48:24 -0500
Date: Thu, 10 Jan 2008 13:48:10 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Matthew <jackdachef@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Fwd: Fwd: laptop / computer hardlocks during execution of
	32bit applications(binaries) on 64bit system (Gentoo)
Message-ID: <20080110124810.GA20579@elte.hu>
References: <e85b9d30712291157v113f5e73yd830ae3c3429092d@mail.gmail.com> <e85b9d30712291504r2f4ef991w33f501ccf0d41c2b@mail.gmail.com> <200712300128.35476.mboton@gmail.com> <20080102084002.GA13636@elte.hu> <e85b9d30801080333y3d6668ccgf20f9666d0326884@mail.gmail.com> <e85b9d30801080340y43fbd4c0sa9b6c9811c7391a1@mail.gmail.com> <47841C41.4060401@zytor.com> <e85b9d30801100105s60ad675ey1ba939491d01a649@mail.gmail.com> <20080110094219.GC17808@elte.hu> <e85b9d30801100443s50ab2b69wbf1a7b4dbd09f002@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e85b9d30801100443s50ab2b69wbf1a7b4dbd09f002@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0005]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Matthew <jackdachef@gmail.com> wrote:

> this also happens with rc7-based kernels, btw

hm, exactly what rc7 based kernel? Vanilla 2.6.24-rc7, built by you? Or 
any patches ontop of it? (x86.git perhaps?)

	Ingo
