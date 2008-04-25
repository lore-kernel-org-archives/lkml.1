Return-Path: <linux-kernel-owner+w=401wt.eu-S1758965AbYDYHNi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758965AbYDYHNi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 03:13:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754114AbYDYHNM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 03:13:12 -0400
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:53269 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753351AbYDYHNK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 03:13:10 -0400
Date: Fri, 25 Apr 2008 09:12:58 +0200
From: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
To: "Huang, Ying" <ying.huang@intel.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
       "Adam J. Richter" <adam@yggdrasil.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
       mingo@elte.hu, tglx@linutronix.de
Subject: Re: [PATCH -mm crypto] AES: x86_64 asm implementation optimization
Message-ID: <20080425071258.GA4460@Chamillionaire.breakpoint.cc>
References: <1207723262.18313.37.camel@caritas-dev.intel.com> <20080416073108.GA13494@Chamillionaire.breakpoint.cc> <1208333949.4322.5.camel@caritas-dev.intel.com> <20080416184016.GA21365@Chamillionaire.breakpoint.cc> <1208403403.4322.27.camel@caritas-dev.intel.com> <20080423223221.GB16683@Chamillionaire.breakpoint.cc> <1209093077.20936.24.camel@caritas-dev.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <1209093077.20936.24.camel@caritas-dev.intel.com>
X-Key-Id: FE3F4706
X-Key-Fingerprint: FFDA BBBB 3563 1B27 75C9  925B 98D5 5C1C FE3F 4706
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Huang, Ying | 2008-04-25 11:11:17 [+0800]:

>Hi, Sebastian,
Hi Huang,

>So I think the reason maybe the read/write port throughput of CPU.
Ah so it is just a local problem you say? I may get my fingers on
another amd box....

>I changed the patches to group the read or write together instead of
>interleaving. Can you help me to test these new patches? The new patches
>is attached with the mail.
Sure.

>Best Regards,
>Huang Ying

Sebastian
