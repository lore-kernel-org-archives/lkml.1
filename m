Return-Path: <linux-kernel-owner+w=401wt.eu-S1759669AbYGKQCR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759669AbYGKQCR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 12:02:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753950AbYGKQCB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 12:02:01 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:50641 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753853AbYGKQCA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 12:02:00 -0400
Date: Fri, 11 Jul 2008 18:01:39 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: mingo@redhat.com, tglx@linutronix.de, linux-kernel@vger.kernel.org,
       iommu@lists.linux-foundation.org, bhavna.sarathy@amd.com,
       robert.richter@amd.com, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 0/16] AMD IOMMU updates
Message-ID: <20080711160139.GB7523@elte.hu>
References: <1215789275-20975-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1215789275-20975-1-git-send-email-joerg.roedel@amd.com>
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


* Joerg Roedel <joerg.roedel@amd.com> wrote:

> Hi,
> 
> this patch series contain updates to the AMD IOMMU driver currently in 
> tip/master. The updates are mostly added comments and fixes for 
> objections by Andrew Morton. Some of Andrews objections are not yet 
> fixed (mostly the ones where I have to touch other subsytems too). The 
> patch series also contains a small bugfix in device table allocation.

applied to tip/x86/amd-iommu - thanks Joerg.

	Ingo
