Return-Path: <linux-kernel-owner+w=401wt.eu-S1754491AbZDFG6P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754491AbZDFG6P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 02:58:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753559AbZDFG56
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 02:57:58 -0400
Received: from smtp.cs.aau.dk ([130.225.194.6]:46577 "EHLO smtp.cs.aau.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753329AbZDFG56 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 02:57:58 -0400
Subject: Re: [Lguest] [PATCH 4/5] lguest: use KVM hypercalls
From: Simon Holm =?ISO-8859-1?Q?Th=F8gersen?= <odie@cs.aau.dk>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: lguest@ozlabs.org, virtualization@lists.osdl.org,
       Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
       Matias Zabaljauregui <zabaljauregui@gmail.com>
In-Reply-To: <200904052234.48483.rusty@rustcorp.com.au>
References: <200903271022.38244.rusty@rustcorp.com.au>
	 <1238709324.5823.8.camel@odie.local>
	 <200904052234.48483.rusty@rustcorp.com.au>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 06 Apr 2009 08:56:39 +0200
Message-Id: <1239000999.6448.821.camel@odie.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.4 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

søn, 05 04 2009 kl. 22:34 +0930, skrev Rusty Russell: 
> On Friday 03 April 2009 08:25:24 Simon Holm Thøgersen wrote:
> > fre, 27 03 2009 kl. 10:22 +1030, skrev Rusty Russell:
> > > From: Matias Zabaljauregui <zabaljauregui@gmail.com>
> > > 
> > > Impact: cleanup
> > > 
> > > This patch allow us to use KVM hypercalls
> > 
> > Something has broken in relation to this change. I'm not sure it is this
> > change itself or one following, but I get the following error when using
> > lguest:
> > 
> > lguest: unhandled trap 6 at 0x418726 (0x0)
> 
> Any chance you didn't rebuild the Launcher?

Nope, I've double and triple checked that. I still kind of expect
something weird at my end though, so I'd be interested to know the
result of others using my config.


Simon

