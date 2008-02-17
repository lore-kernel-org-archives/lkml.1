Return-Path: <linux-kernel-owner+w=401wt.eu-S1755394AbYBQTyQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755394AbYBQTyQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 14:54:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752300AbYBQTyB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 14:54:01 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:38587 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752073AbYBQTyA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 14:54:00 -0500
Date: Sun, 17 Feb 2008 20:53:44 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Roland McGrath <roland@redhat.com>, Rene Herman <rene.herman@keyaccess.nl>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       linux-kbuild@vger.kernel.org
Subject: Re: 2.6.25-rc2 vdso_install breaks user "make install"
Message-ID: <20080217195344.GC20850@elte.hu>
References: <47B6592A.6030200@keyaccess.nl> <20080216034211.8DD03270193@magilla.localdomain> <20080216113610.GB11362@uranus.ravnborg.org> <20080217193514.GJ14588@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080217193514.GJ14588@uranus.ravnborg.org>
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

> Roland - if you agree will you please submit the patch
> to the x86 people.
> You can tag it:
> Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
> or Acked-by: Sam Ravnborg <sam@ravnborg.org>

i've picked it up, thanks.

	Ingo
