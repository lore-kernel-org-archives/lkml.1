Return-Path: <linux-kernel-owner+w=401wt.eu-S1755095AbYIEPJT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755095AbYIEPJT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 11:09:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753765AbYIEPJM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 11:09:12 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:50642 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753772AbYIEPJL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 11:09:11 -0400
Date: Fri, 5 Sep 2008 17:08:59 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: make sure the CPA test code's use of
	_PAGE_UNUSED1 is obvious
Message-ID: <20080905150854.GE10292@elte.hu>
References: <48B7117F.8090008@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48B7117F.8090008@goop.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-0.5 required=5.9 tests=BAYES_20 autolearn=no SpamAssassin version=3.2.3
	-0.5 BAYES_20               BODY: Bayesian spam probability is 5 to 20%
	[score: 0.1876]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> The CPA test code uses _PAGE_UNUSED1, so make sure its obvious.
> 
> Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

applied to tip/x86/cpa - thanks Jeremy.

	Ingo
