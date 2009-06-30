Return-Path: <linux-kernel-owner+w=401wt.eu-S1760820AbZF3XT5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760820AbZF3XT5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 19:19:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758212AbZF3XSY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 19:18:24 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:48226 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757388AbZF3XSX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 19:18:23 -0400
Date: Wed, 1 Jul 2009 00:14:34 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Ingo Molnar <mingo@elte.hu>
Cc: Jaswinder Singh Rajput <jaswinder@kernel.org>,
       Paul Mackerras <paulus@samba.org>, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -tip] perf_counter: Add Generalized Hardware FPU support
 for AMD
Message-ID: <20090701001434.2e4ec5e4@lxorguk.ukuu.org.uk>
In-Reply-To: <20090630224220.GI1241@elte.hu>
References: <1246267985.3185.3.camel@hpdv5.satnam>
	<20090630101105.GF6942@elte.hu>
	<1246368049.3026.11.camel@hpdv5.satnam>
	<20090630224220.GI1241@elte.hu>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> '3dnow' is an AMD marketing term. (and is long obsolete)

And an instruction set extension as well so different to SSE

(also be careful of MMX as there is MMX and MMX-EXT (Cyrix/AMD).
