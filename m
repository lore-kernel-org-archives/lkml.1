Return-Path: <linux-kernel-owner+w=401wt.eu-S1756043AbYCKMWs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756043AbYCKMWs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 08:22:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750959AbYCKMWk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 08:22:40 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:35038 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750750AbYCKMWk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 08:22:40 -0400
Date: Tue, 11 Mar 2008 13:22:22 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Gregory Haskins <ghaskins@novell.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] Revert "cpu hotplug: adjust
	root-domain->onlinespan in response to hotplug
Message-ID: <20080311122222.GA7959@elte.hu>
References: <20080310205241.9571.38832.stgit@novell1.haskins.net> <20080311085201.GD25110@elte.hu> <47D63CB3.BA47.005A.0@novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47D63CB3.BA47.005A.0@novell.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: 0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.5 required=5.9 tests=BAYES_40 autolearn=no SpamAssassin version=3.2.3
	0.5 BAYES_40               BODY: Bayesian spam probability is 20 to 40%
	[score: 0.3343]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Gregory Haskins <ghaskins@novell.com> wrote:

> Also, for the second patch, make sure you pick up "v2" which has both 
> DYING/DYING_FROZEN.  The hotplug gurus indicated that I need both to 
> work properly.

yes, it is v2 that i have.

	Ingo
