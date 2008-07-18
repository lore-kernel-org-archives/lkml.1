Return-Path: <linux-kernel-owner+w=401wt.eu-S1760181AbYGRQo2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760181AbYGRQo2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 12:44:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753040AbYGRQoU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 12:44:20 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:38211 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751686AbYGRQoT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 12:44:19 -0400
Date: Fri, 18 Jul 2008 18:43:56 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: mingo@redhat.com, tglx@linutronix.de, linux-kernel@vger.kernel.org,
       iommu@lists.linux-foundation.org, bhavna.sarathy@amd.com,
       robert.richter@amd.com
Subject: Re: [PATCH] AMD IOMMU: set iommu for device from ACPI code too
Message-ID: <20080718164356.GC6875@elte.hu>
References: <1216059078-4054-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1216059078-4054-1-git-send-email-joerg.roedel@amd.com>
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

> The device<->iommu relationship has to be set from the information in 
> the ACPI table too. This patch adds this logic to the driver.

applied to tip/x86/amd-iommu - thanks Joerg.

	Ingo
