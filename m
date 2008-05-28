Return-Path: <linux-kernel-owner+w=401wt.eu-S1753490AbYE1S04@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753490AbYE1S04 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 14:26:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751940AbYE1S0q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 14:26:46 -0400
Received: from kirk.serum.com.pl ([213.77.9.205]:64482 "EHLO serum.com.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751340AbYE1S0q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 14:26:46 -0400
Date: Wed, 28 May 2008 19:25:59 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Jan Engelhardt <jengelh@medozas.de>
cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [X86] Fix up silly i1586 boot message.
In-Reply-To: <alpine.LNX.1.10.0805282001180.19264@fbirervta.pbzchgretzou.qr>
Message-ID: <Pine.LNX.4.55.0805281916480.29522@cliff.in.clinika.pl>
References: <20080528165713.GA412@redhat.com>
 <alpine.LNX.1.10.0805281943330.19264@fbirervta.pbzchgretzou.qr>
 <Pine.LNX.4.55.0805281850540.29522@cliff.in.clinika.pl>
 <alpine.LNX.1.10.0805282001180.19264@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 May 2008, Jan Engelhardt wrote:

> 801586 or 81586, that is the question. Or 80F86.

 Hmm, 801586 should be fine as with Intel 80 used to stand for
microprocessors and 81586 would be confusing as I think 81 was used for
RAM devices (82 stood for peripherals, BTW).  My vote is for 80F86 though,
with "F" standing for "fast" as in the 74 TTL series. ;)

  Maciej
