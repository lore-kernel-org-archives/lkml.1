Return-Path: <linux-kernel-owner+w=401wt.eu-S1756644AbYCVMKR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756644AbYCVMKR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2008 08:10:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754784AbYCVMKE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Mar 2008 08:10:04 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:56840 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754641AbYCVMKC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2008 08:10:02 -0400
Date: Sat, 22 Mar 2008 13:09:50 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Valdis.Kletnieks@vt.edu
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: Hoo-fscking-ray - (was Re: 2.6.25-rc3-mm1 - BUG at system
	shutdown time
Message-ID: <20080322120949.GA941@elte.hu>
References: <20080304011928.e8c82c0c.akpm@linux-foundation.org> <10815.1204862325@turing-police.cc.vt.edu> <20080312003227.a94580e8.akpm@linux-foundation.org> <4351.1205374751@turing-police.cc.vt.edu> <20080321134128.GO27245@elte.hu> <3343.1206128318@turing-police.cc.vt.edu> <20080321195813.GC16179@elte.hu> <4945.1206129958@turing-police.cc.vt.edu> <20080321201211.GA21609@elte.hu> <3370.1206155478@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3370.1206155478@turing-police.cc.vt.edu>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.1
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.1 required=5.9 tests=BAYES_05 autolearn=no SpamAssassin version=3.2.3
	-1.1 BAYES_05               BODY: Bayesian spam probability is 1 to 5%
	[score: 0.0171]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Valdis.Kletnieks@vt.edu <Valdis.Kletnieks@vt.edu> wrote:

> Given that -mmotm isn't showing the problem, I'm having a hard time 
> coming up with enthusiasm to keep chasing it.  If I see it happen 
> again in a -mm or Linus kernel, I'll restart the chase then....

if it ever reappears then please check x86/latest first (without any 
other -mm bits) and notify us.

	Ingo
