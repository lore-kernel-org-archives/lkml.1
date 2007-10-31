Return-Path: <linux-kernel-owner+w=401wt.eu-S1757004AbXJaAta@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757004AbXJaAta (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 20:49:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752778AbXJaAtX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 20:49:23 -0400
Received: from ozlabs.org ([203.10.76.45]:48459 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751122AbXJaAtW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 20:49:22 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH] x86: Fix boot protocol KEEP_SEGMENTS check.
Date: Wed, 31 Oct 2007 11:49:22 +1100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Jeremy Fitzhardinge <jeremy@xensource.com>,
       Vivek Goyal <vgoyal@in.ibm.com>,
       James Bottomley <James.Bottomley@hansenpartnership.com>,
       Zachary Amsden <zach@vmware.com>, Andi Kleen <ak@suse.de>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
References: <m1r6jh3hun.fsf@ebiederm.dsl.xmission.com>
In-Reply-To: <m1r6jh3hun.fsf@ebiederm.dsl.xmission.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710311149.23006.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 27 October 2007 03:29:04 Eric W. Biederman wrote:
> The kernel only ever supports 1 version of the boot protocol
> so there is no need to check the boot protocol revision to
> see if a feature is supported.

OK, I'm completely confused, so this is probably a v. dumb question.  Doesn't 
this boot header come from the boot loader?

Rusty.
