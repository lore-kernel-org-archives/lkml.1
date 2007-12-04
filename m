Return-Path: <linux-kernel-owner+w=401wt.eu-S1754090AbXLDMyj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754090AbXLDMyj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 07:54:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752838AbXLDMyb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 07:54:31 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:35480 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752745AbXLDMyb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 07:54:31 -0500
Date: Tue, 4 Dec 2007 13:54:08 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Kumar Gala <galak@kernel.crashing.org>
Cc: mingo@redhat.com, Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linux-kernel@vger.kernel.org
Subject: Re: why is kmap_prot not always a define?
Message-ID: <20071204125408.GC31590@elte.hu>
References: <BE453CED-64E1-46FD-8C13-D752F5B63A9D@kernel.crashing.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BE453CED-64E1-46FD-8C13-D752F5B63A9D@kernel.crashing.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.1
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.1 required=5.9 tests=BAYES_05 autolearn=no SpamAssassin version=3.2.3
	-1.1 BAYES_05               BODY: Bayesian spam probability is 1 to 5%
	[score: 0.0154]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Kumar Gala <galak@kernel.crashing.org> wrote:

> Is there some reason why kmap_prot isn't just a #define on all archs?

none that i can remember - why do you ask? Do you have some cleanup 
idea?

	Ingo
