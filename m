Return-Path: <linux-kernel-owner+w=401wt.eu-S1755253AbZDENFN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755253AbZDENFN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Apr 2009 09:05:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752286AbZDENE6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Apr 2009 09:04:58 -0400
Received: from ozlabs.org ([203.10.76.45]:49368 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752119AbZDENE5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Apr 2009 09:04:57 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Simon Holm =?utf-8?q?Th=C3=B8gersen?= <odie@cs.aau.dk>
Subject: Re: [Lguest] [PATCH 4/5] lguest: use KVM hypercalls
Date: Sun, 5 Apr 2009 22:34:47 +0930
User-Agent: KMail/1.11.2 (Linux/2.6.27-11-generic; KDE/4.2.2; i686; ; )
Cc: lguest@ozlabs.org, virtualization@lists.osdl.org,
       Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
       Matias Zabaljauregui <zabaljauregui@gmail.com>
References: <200903271022.38244.rusty@rustcorp.com.au> <1238709324.5823.8.camel@odie.local>
In-Reply-To: <1238709324.5823.8.camel@odie.local>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200904052234.48483.rusty@rustcorp.com.au>
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 03 April 2009 08:25:24 Simon Holm Thøgersen wrote:
> fre, 27 03 2009 kl. 10:22 +1030, skrev Rusty Russell:
> > From: Matias Zabaljauregui <zabaljauregui@gmail.com>
> > 
> > Impact: cleanup
> > 
> > This patch allow us to use KVM hypercalls
> 
> Something has broken in relation to this change. I'm not sure it is this
> change itself or one following, but I get the following error when using
> lguest:
> 
> lguest: unhandled trap 6 at 0x418726 (0x0)

Any chance you didn't rebuild the Launcher?

Rusty.
