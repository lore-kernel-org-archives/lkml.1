Return-Path: <linux-kernel-owner+w=401wt.eu-S1752087AbZEJH2h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752087AbZEJH2h (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 May 2009 03:28:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751502AbZEJH22
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 May 2009 03:28:28 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:60443 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751352AbZEJH22 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 May 2009 03:28:28 -0400
Date: Sun, 10 May 2009 09:28:11 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Rakib Mullick <rakib.mullick@gmail.com>
Cc: Sam Ravnborg <sam@ravnborg.org>, Marcin Slusarz <marcin.slusarz@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: Fix false positive section mismatch in apic.
Message-ID: <20090510072811.GA12955@elte.hu>
References: <b9df5fa10905090235s4bfd26a8o979f93809c9727ad@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b9df5fa10905090235s4bfd26a8o979f93809c9727ad@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0034]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Rakib Mullick <rakib.mullick@gmail.com> wrote:

>  Sorry guys , for being late. My system was out of order for a week.
> 
> 
>  x86: Fix false positive section mismatch warnings in the apic code
> 
> ----
> Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
> Signed-off-by: Rakib Mullick <rakib.mullick@gmail.com>

Ok, since the patch came from Sam i applied it as a From: Sam patch 
- and added this comment above your signoff line:

    Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
    [ modified and tested it ]
    Signed-off-by: Rakib Mullick <rakib.mullick@gmail.com>

To denote your modifications on it. Hope this is fine with everyone.

	Ingo
