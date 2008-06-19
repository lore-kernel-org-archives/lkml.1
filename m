Return-Path: <linux-kernel-owner+w=401wt.eu-S1758708AbYFSMVT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758708AbYFSMVT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2008 08:21:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754915AbYFSMVG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jun 2008 08:21:06 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:54876 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754894AbYFSMVE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2008 08:21:04 -0400
Date: Thu, 19 Jun 2008 14:20:40 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jordan Crouse <jordan.crouse@amd.com>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
       linux-geode@lists.infradead.org
Subject: Re: [PATCH] geode:  Add a VSA2 ID for General Software
Message-ID: <20080619122040.GG7640@elte.hu>
References: <20080618173438.GA9130@cosmic.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080618173438.GA9130@cosmic.amd.com>
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


* Jordan Crouse <jordan.crouse@amd.com> wrote:

> We have learned from bitter experience that one of the Geode BIOS 
> vendors, General Software, uses a different ID for their VSA 
> implementation then the canonical version from AMD & Insyde.  This 
> patch adds the ID to the have_geode_vsa2() check, and should make lxfb 
> work again on many GSW platforms.  If Linus is planning another -rcX 
> revision it would be good to try and get this in, otherwise please 
> schedule this for the stable series and 2.6.27.

applied to tip/x86/urgent. Thanks,

	Ingo
