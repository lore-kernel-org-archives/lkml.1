Return-Path: <linux-kernel-owner+w=401wt.eu-S1752562AbZIWU4n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752562AbZIWU4n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 16:56:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752419AbZIWU4l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 16:56:41 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:44780 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751814AbZIWU4l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 16:56:41 -0400
Date: Wed, 23 Sep 2009 22:56:36 +0200
From: Ingo Molnar <mingo@elte.hu>
To: James Morris <jmorris@namei.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       David Howells <dhowells@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Eric Paris <eparis@redhat.com>, linux-security-module@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [GIT] bugfixes for the security subsystem
Message-ID: <20090923205636.GB25418@elte.hu>
References: <alpine.LRH.2.00.0909240643380.5253@tundra.namei.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.00.0909240643380.5253@tundra.namei.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* James Morris <jmorris@namei.org> wrote:

> Eric Paris (1):
>       SELinux: do not destroy the avc_cache_nodep

btw., FYI, i have tested this patch separately for the past two days and 
with that fix (and your earlier fixes) all the security related crashes 
i reported are fixed.

Thanks,

	Ingo
