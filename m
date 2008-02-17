Return-Path: <linux-kernel-owner+w=401wt.eu-S1756168AbYBQTJi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756168AbYBQTJi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 14:09:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752295AbYBQTJ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 14:09:29 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:55321 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752275AbYBQTJ2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 14:09:28 -0500
Date: Sun, 17 Feb 2008 20:09:11 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>, ak@suse.de, tglx@linutronix.de,
       hpa@zytor.com, linux-kernel@vger.kernel.org
Subject: Re: [patch 1/2] x86: lds - Use PAGE_SIZE instead of numeric
	constant
Message-ID: <20080217190911.GK19263@elte.hu>
References: <20080217151716.274134094@gmail.com> <20080217151924.985325396@gmail.com> <20080217185735.GA14588@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080217185735.GA14588@uranus.ravnborg.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Sam Ravnborg <sam@ravnborg.org> wrote:

> On Sun, Feb 17, 2008 at 06:17:17PM +0300, Cyrill Gorcunov wrote:
> > It's much better to use PAGE_SIZE then magic 4096
> > (though it's almost synonym in most cases on x86 but
> > not for *all* cases ;)
> 
> Thanks Cyrill.
> 
> > 
> > Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
> Acked-by: Sam Ravnborg <sam@ravnborg.org>

thanks - applied.

	Ingo
