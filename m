Return-Path: <linux-kernel-owner+w=401wt.eu-S1754791AbYIEPrU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754791AbYIEPrU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 11:47:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752336AbYIEPrM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 11:47:12 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:41397 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753391AbYIEPrM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 11:47:12 -0400
Date: Fri, 5 Sep 2008 17:46:55 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Alex Nixon <alex.nixon@citrix.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [PATCH] x86/paravirt: Remove duplicate
	paravirt_pagetable_setup_{start,done}()
Message-ID: <20080905154655.GH10292@elte.hu>
References: <1220449000-15264-1-git-send-email-alex.nixon@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1220449000-15264-1-git-send-email-alex.nixon@citrix.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.1
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.1 required=5.9 tests=BAYES_05 autolearn=no SpamAssassin version=3.2.3
	-1.1 BAYES_05               BODY: Bayesian spam probability is 1 to 5%
	[score: 0.0202]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Alex Nixon <alex.nixon@citrix.com> wrote:

> They were already called once in arch/x86/kernel/setup.c - we don't need to call them again.
> 
> Signed-off-by: Alex Nixon <alex.nixon@citrix.com>
> Cc: Jeremy Fitzhardinge <jeremy@goop.org>
> Cc: Ingo Molnar <mingo@elte.hu>

applied to tip/x86/paravirt - thanks.

	Ingo
