Return-Path: <linux-kernel-owner+w=401wt.eu-S1761226AbZAWJ0S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761226AbZAWJ0S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2009 04:26:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754038AbZAWJ0H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Jan 2009 04:26:07 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:37688 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753734AbZAWJ0F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2009 04:26:05 -0500
Date: Fri, 23 Jan 2009 10:25:56 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Tejun Heo <tj@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Fwd: kernel panic when using disable_mtrr_trim [was: Re:
	memory beyond4GB invisible to the system even though
	CONFIG_HIGHMEM64G=y]]
Message-ID: <20090123092556.GC29820@elte.hu>
References: <49763718.7010501@kernel.org> <86802c440901201249v3c877a88ie8e5f3bbf6abb871@mail.gmail.com> <49794422.2080109@kernel.org> <49797634.7040500@kernel.org> <4979771E.5050001@kernel.org> <49797788.2080603@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49797788.2080603@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > Hmm... weird.  Can you please attach the .config file you used and the 
> > commit ID and the version of toolchain?  I'll try to reproduce it 
> > here.

Yinghai, please send the binutils package version too - if this is a 
linker bug or linker interaction then it might matter.

GCC is 4.3.2 according to your boot log:

   (gcc version 4.3.2 [gcc-4_3-branch revision 141291] 

	Ingo

