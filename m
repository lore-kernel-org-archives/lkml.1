Return-Path: <linux-kernel-owner+w=401wt.eu-S1753004AbYKXJGH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753004AbYKXJGH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 04:06:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751682AbYKXJFu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 04:05:50 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:50473 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751452AbYKXJFt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 04:05:49 -0500
Date: Mon, 24 Nov 2008 10:05:33 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Denis V. Lunev" <den@openvz.org>
Cc: akpm@linux-foundation.org, tglx@linutronix.de, mingo@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: correct link to HPET timer specification
Message-ID: <20081124090533.GB25218@elte.hu>
References: <1227515316-28274-1-git-send-email-den@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1227515316-28274-1-git-send-email-den@openvz.org>
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


* Denis V. Lunev <den@openvz.org> wrote:

> Original link is dead.
> 
> Signed-off-by: Denis V. Lunev <den@openvz.org>
> ---
>  arch/x86/Kconfig    |    2 +-
>  drivers/char/hpet.c |    2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)

applied to tip/timers/hpe, thanks Denis!

	Ingo
