Return-Path: <linux-kernel-owner+w=401wt.eu-S1762949AbZEGWBb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762949AbZEGWBb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 18:01:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762814AbZEGWBB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 18:01:01 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:60556 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762949AbZEGWBB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 18:01:01 -0400
Date: Fri, 8 May 2009 00:00:21 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Borislav Petkov <borislav.petkov@amd.com>
Cc: akpm@linux-foundation.org, greg@kroah.com, norsk5@yahoo.com,
       tglx@linutronix.de, hpa@zytor.com, mchehab@redhat.com, aris@redhat.com,
       edt@aei.ca, linux-kernel@vger.kernel.org,
       Doug Thompson <dougthompson@xmission.com>
Subject: Re: [PATCH 20/21] amd64_edac: add ECC reporting initializers
Message-ID: <20090507220021.GC28770@elte.hu>
References: <1241704183-29223-1-git-send-email-borislav.petkov@amd.com> <1241704183-29223-21-git-send-email-borislav.petkov@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1241704183-29223-21-git-send-email-borislav.petkov@amd.com>
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


Ok, this #20 patch - and most of the other 19 have problems with 
similar patterns as #21. Please apply those concepts to all patches. 
Those issues are enough work cut out i think - i'll review your next 
series in detail again.

Thanks,

	Ingo
