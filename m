Return-Path: <linux-kernel-owner+w=401wt.eu-S1754008AbYLSFoU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754008AbYLSFoU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 00:44:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751647AbYLSFoE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 00:44:04 -0500
Received: from ozlabs.org ([203.10.76.45]:50657 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751535AbYLSFoC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 00:44:02 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] Define smp_call_function_many for UP
Date: Fri, 19 Dec 2008 16:13:57 +1030
User-Agent: KMail/1.10.3 (Linux/2.6.27-9-generic; KDE/4.1.3; i686; ; )
Cc: Hollis Blanchard <hollisb@us.ibm.com>, Avi Kivity <avi@redhat.com>,
       "kvm-devel" <kvm@vger.kernel.org>, linux-kernel@vger.kernel.org
References: <20081208160945.7535A25006E@cleopatra.tlv.redhat.com> <200812190840.13995.rusty@rustcorp.com.au> <alpine.LFD.2.00.0812181415480.14014@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0812181415480.14014@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812191613.57719.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 19 December 2008 08:46:37 Linus Torvalds wrote:
> 
> On Fri, 19 Dec 2008, Rusty Russell wrote:
> >
> > Linus, please apply.  Otherwise those using it in transition patches (eg. kvm)
> > can't compile with CONFIG_SMP=n:
> 
> Umm. I already applied this a long time ago. It's commit 
> d2ff911882b6bc693d86ca9566daac70aacbb2b3

Wow, it's like Santa came early!

Thanks,
Rusty.
