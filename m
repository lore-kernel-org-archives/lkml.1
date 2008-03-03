Return-Path: <linux-kernel-owner+w=401wt.eu-S1758171AbYCCIrn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758171AbYCCIrn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 03:47:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756939AbYCCIre
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 03:47:34 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:49025 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754349AbYCCIrd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 03:47:33 -0500
Date: Mon, 3 Mar 2008 09:47:00 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: Gabriel C <nix.or.die@googlemail.com>,
       Laurent Riffard <laurent.riffard@free.fr>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Stuart Bennett <sb476@cam.ac.uk>, Len Brown <lenb@kernel.org>,
       tglx@linutronix.de, mingo@redhat.com
Subject: Re: 2.6.25-rc2-mm1: WARNING at arch/x86/mm/ioremap.c:129
Message-ID: <20080303084700.GA16195@elte.hu>
References: <20080216002522.9c4bd0fb.akpm@linux-foundation.org> <47B7553D.5040601@free.fr> <47C0BDE2.4020402@googlemail.com> <47C0DB7D.70407@linux.intel.com> <47C2ED51.4000105@googlemail.com> <47C344E5.5050205@linux.intel.com> <20080302155348.GA74305@gandalf.sssup.it> <47CADC9D.9090403@linux.intel.com> <20080303084611.GA15943@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080303084611.GA15943@elte.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Ingo Molnar <mingo@elte.hu> wrote:

> well upstream doesnt have the warning anymore, i queued up the patch 
> below into x86.git#testing.

i mean, x86.git#testing doesnt have the warning anymore.

	Ingo
