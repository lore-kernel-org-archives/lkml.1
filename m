Return-Path: <linux-kernel-owner+w=401wt.eu-S935332AbYBMV7v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935332AbYBMV7v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 16:59:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933556AbYBMVig
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 16:38:36 -0500
Received: from mx1.redhat.com ([66.187.233.31]:36902 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933547AbYBMVif (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 16:38:35 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Adrian Bunk <bunk@kernel.org>
X-Fcc: ~/Mail/linus
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] x86: make mxcsr_feature_mask static again
In-Reply-To: Adrian Bunk's message of  Wednesday, 13 February 2008 23:29:33 +0200 <20080213212933.GE3383@cs181133002.pp.htv.fi>
References: <20080213212933.GE3383@cs181133002.pp.htv.fi>
X-Antipastobozoticataclysm: Bariumenemanilow
Message-Id: <20080213213832.6AC8D270192@magilla.localdomain>
Date: Wed, 13 Feb 2008 13:38:32 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Good change.  Making it global was needed temporarily in between some of
the i387 unification patches, but is unnecessary after the final merge.


Thanks,
Roland
