Return-Path: <linux-kernel-owner+w=401wt.eu-S1752734AbYIXHe0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752734AbYIXHe0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 03:34:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751216AbYIXHeS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 03:34:18 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:45585 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751056AbYIXHeS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 03:34:18 -0400
Date: Wed, 24 Sep 2008 09:34:00 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Katz <katzj@redhat.com>
Cc: mingo@redhat.com, dsaxena@laptop.org, linux-kernel@vger.kernel.org,
       dilinger@laptop.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] Disable apm on the olpc
Message-ID: <20080924073400.GB3655@elte.hu>
References: <1222221240-6028-1-git-send-email-katzj@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1222221240-6028-1-git-send-email-katzj@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0017]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jeremy Katz <katzj@redhat.com> wrote:

> The OLPC doesn't support APM but also doesn't have DMI, so we can't 
> detect and disable it based on DMI data.  So, just disable based on 
> machine_is_olpc()
> 
> Signed-off-by: Jeremy Katz <katzj@redhat.com>

applied to tip/x86/urgent, thanks Jeremy!

	Ingo
