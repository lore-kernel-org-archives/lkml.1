Return-Path: <linux-kernel-owner+w=401wt.eu-S933034AbXK2Tdv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933034AbXK2Tdv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 14:33:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761136AbXK2Tdn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 14:33:43 -0500
Received: from mfe1.polimi.it ([131.175.12.23]:51877 "EHLO polimi.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758001AbXK2Tdm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 14:33:42 -0500
Date: Thu, 29 Nov 2007 20:25:46 +0100
From: Stefano Brivio <stefano.brivio@polimi.it>
To: Dave Jones <davej@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-kernel@vger.kernel.org, Michael Buesch <mb@bu3sch.de>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, Len Brown <lenb@kernel.org>
Subject: Re: [BUG] jiffies counter leaps in 2.6.24-rc3
Message-ID: <20071129202546.7a65a13c@morte>
In-Reply-To: <20071129182402.GE12481@redhat.com>
References: <20071124175112.58193424@morte>
	<200711241948.58881.rjw@sisk.pl>
	<20071124194635.58f5a44b@morte>
	<200711242031.26134.rjw@sisk.pl>
	<20071129095034.24b3fc59@morte>
	<20071129103511.GD10577@elte.hu>
	<20071129174548.GC12481@redhat.com>
	<20071129185743.46daa8ad@morte>
	<20071129182402.GE12481@redhat.com>
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-PMX-Version: 5.3.3.310218, Antispam-Engine: 2.5.2.311128, Antispam-Data: 2007.11.6.30824
X-PerlMx-Spam: Gauge=II, Probability=22%, Report='RELAY_IN_PBL_11 2.5, BODY_SIZE_300_399 0, RDNS_GENERIC_POOLED 0, RDNS_SUSP 0, RDNS_SUSP_GENERIC 0, RELAY_IN_PBL 0, __CT 0, __CTE 0, __CT_TEXT_PLAIN 0, __HAS_MSGID 0, __HAS_X_MAILER 0, __MIME_TEXT_ONLY 0, __MIME_VERSION 0, __SANE_MSGID 0'
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Nov 2007 13:24:02 -0500
Dave Jones <davej@redhat.com> wrote:

> On Thu, Nov 29, 2007 at 06:57:43PM +0100, Stefano Brivio wrote:

>  > Do you want me to comment out adjust_jiffies() and see what happens?
>  
> Just for laughs, why not.

I wanted to laugh, but the behaviour didn't change at all. How boring.


-- 
Ciao
Stefano
