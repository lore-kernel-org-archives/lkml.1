Return-Path: <linux-kernel-owner+w=401wt.eu-S1755346AbYE2AMP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755346AbYE2AMP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 20:12:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751829AbYE2AMA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 20:12:00 -0400
Received: from kirk.serum.com.pl ([213.77.9.205]:61007 "EHLO serum.com.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751750AbYE2AL7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 20:11:59 -0400
Date: Thu, 29 May 2008 01:10:53 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: "H. Peter Anvin" <hpa@zytor.com>
cc: Jan Engelhardt <jengelh@medozas.de>, Dave Jones <davej@redhat.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [X86] Fix up silly i1586 boot message.
In-Reply-To: <483DB2D5.8050502@zytor.com>
Message-ID: <Pine.LNX.4.55.0805290102340.29522@cliff.in.clinika.pl>
References: <20080528165713.GA412@redhat.com>
 <alpine.LNX.1.10.0805281943330.19264@fbirervta.pbzchgretzou.qr>
 <Pine.LNX.4.55.0805281850540.29522@cliff.in.clinika.pl>
 <alpine.LNX.1.10.0805282001180.19264@fbirervta.pbzchgretzou.qr>
 <Pine.LNX.4.55.0805281916480.29522@cliff.in.clinika.pl> <483DB2D5.8050502@zytor.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 May 2008, H. Peter Anvin wrote:

> >  Hmm, 801586 should be fine as with Intel 80 used to stand for
> > microprocessors and 81586 would be confusing as I think 81 was used for
> > RAM devices (82 stood for peripherals, BTW).  My vote is for 80F86 though,
> > with "F" standing for "fast" as in the 74 TTL series. ;)
> > 
> 
> uname reports i686 on these chips.  The rest is ridiculous.

 Intel started it first with picking up a ridiculous number for the family
ID for the P4 line.  There is no technical justification for not keeping
these numbers consecutive.  Or keeping it at 6 actually if the P4 is meant
to be seen by software as the Pentium Pro and the rest of the P6 gang.

  Maciej
