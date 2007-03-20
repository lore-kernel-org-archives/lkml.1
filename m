Return-Path: <linux-kernel-owner+w=401wt.eu-S1752054AbXCTWlr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752054AbXCTWlr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 18:41:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752044AbXCTWlr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 18:41:47 -0400
Received: from ozlabs.org ([203.10.76.45]:35573 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752042AbXCTWlp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 18:41:45 -0400
Subject: Re: [patch 13/26] Xen-paravirt_ops: Consistently wrap paravirt ops
	callsites to make them patchable
From: Rusty Russell <rusty@rustcorp.com.au>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>, Zachary Amsden <zach@vmware.com>,
       Andi Kleen <ak@muc.de>, David Miller <davem@davemloft.net>,
       mingo@elte.hu, akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       virtualization@lists.osdl.org, xen-devel@lists.xensource.com,
       chrisw@sous-sol.org, anthony@codemonkey.ws, netdev@vger.kernel.org
In-Reply-To: <m1mz27sy82.fsf@ebiederm.dsl.xmission.com>
References: <20070316.023331.59468179.davem@davemloft.net>
	 <45FB005D.9060809@goop.org>
	 <1174127638.8897.75.camel@localhost.localdomain>
	 <20070318.003309.71088169.davem@davemloft.net>
	 <20070318120814.GA45869@muc.de>
	 <1174272469.11680.23.camel@localhost.localdomain>
	 <m1648xxf93.fsf@ebiederm.dsl.xmission.com>
	 <Pine.LNX.4.64.0703191134190.6730@woody.linux-foundation.org>
	 <1174348905.11680.54.camel@localhost.localdomain>
	 <45FF4043.4000805@vmware.com> <45FF770C.7050301@goop.org>
	 <Pine.LNX.4.64.0703200805450.6730@woody.linux-foundation.org>
	 <m1mz27sy82.fsf@ebiederm.dsl.xmission.com>
Content-Type: text/plain
Date: Wed, 21 Mar 2007 09:41:16 +1100
Message-Id: <1174430476.11680.123.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-03-20 at 09:58 -0600, Eric W. Biederman wrote:
> Looking at the above code snippet.  I guess it is about time to
> merge our per_cpu and pda variables...

Indeed, thanks for the prod.  Now 2.6.21-rc4-mm1 is out, I'll resend the
patches.

Cheers,
Rusty.


