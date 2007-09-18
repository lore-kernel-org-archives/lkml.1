Return-Path: <linux-kernel-owner+w=401wt.eu-S1756513AbXIRBib@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756513AbXIRBib (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 21:38:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754381AbXIRBiX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 21:38:23 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:11643 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754573AbXIRBiW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 21:38:22 -0400
Date: Mon, 17 Sep 2007 18:37:49 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Satyam Sharma <satyam@infradead.org>
Cc: Paul Mackerras <paulus@samba.org>,
       Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>, linuxppc-dev@ozlabs.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] powerpc: Avoid pointless WARN_ON(irqs_disabled()) from
 panic codepath
Message-Id: <20070917183749.fd690505.randy.dunlap@oracle.com>
In-Reply-To: <alpine.LFD.0.999.0709180511070.8863@enigma.security.iitk.ac.in>
References: <46EA5CEB.7020104@linux.vnet.ibm.com>
	<a781481a0709140337u2c26f770h2af6d457bc39f280@mail.gmail.com>
	<alpine.LFD.0.999.0709180511070.8863@enigma.security.iitk.ac.in>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Sep 2007 05:13:40 +0530 (IST) Satyam Sharma wrote:

> Untested (not even compile-tested) patch.
> Could someone point me to ppc32/64 cross-compilers for i386?

OSDL had some, but those are gone now.
I downloaded all of them and still use them, although it would
be good to have some more recent versions of them.

I put the power* compiler tarballs here:

http://userweb.kernel.org/~rdunlap/cross-compilers/

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
