Return-Path: <linux-kernel-owner+w=401wt.eu-S1754151AbYGII6o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754151AbYGII6o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 04:58:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755613AbYGII62
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 04:58:28 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:59907 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755472AbYGII61 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 04:58:27 -0400
Date: Wed, 9 Jul 2008 10:57:41 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: mingo@redhat.com, tglx@linutronix.de, linux-kernel@vger.kernel.org,
       iommu@lists.linux-foundation.org,
       Robert Richter <robert.richter@amd.com>,
       Bhavna Sarathy <Bhavna.Sarathy@amd.com>
Subject: Re: [PATCH] AMD IOMMU: ignore detection of GART IOMMU
Message-ID: <20080709085741.GB6267@elte.hu>
References: <1215521236-21269-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1215521236-21269-1-git-send-email-joerg.roedel@amd.com>
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

> One of the last IOMMU updates covered a bug in the AMD IOMMU code. The 
> early detection code does not succeed if the GART is already detected. 
> This patch fixes this.

applied to tip/x86/amd-iommu - thanks Joerg.

	Ingo
