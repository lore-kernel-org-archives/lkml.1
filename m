Return-Path: <linux-kernel-owner+w=401wt.eu-S1757453AbYGZNqi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757453AbYGZNqi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2008 09:46:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756805AbYGZNqY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jul 2008 09:46:24 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:36340 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754647AbYGZNqW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2008 09:46:22 -0400
Date: Sat, 26 Jul 2008 15:46:03 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: mingo@redhat.com, tglx@linutronix.de, linux-kernel@vger.kernel.org,
       iommu@lists.linux-foundation.org, bhavna.sarathy@amd.com,
       robert.richter@amd.com, Wei Wang <wei.wang2@amd.com>
Subject: Re: [PATCH] AMD IOMMU: include amd_iommu_last_bdf in device
	initialization
Message-ID: <20080726134603.GE4401@elte.hu>
References: <1216984070-8677-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1216984070-8677-1-git-send-email-joerg.roedel@amd.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0007]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Joerg Roedel <joerg.roedel@amd.com> wrote:

> All the values read while searching for amd_iommu_last_bdf are defined 
> as inclusive. Let the code handle this value as such. Found by Wei 
> Wang. Thanks Wei.

applied to tip/x86/urgent, thanks Joerg.

	Ingo
