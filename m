Return-Path: <linux-kernel-owner+w=401wt.eu-S1754859AbYIHSBn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754859AbYIHSBn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 14:01:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752421AbYIHSBf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 14:01:35 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:47008 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751767AbYIHSBf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 14:01:35 -0400
Date: Mon, 8 Sep 2008 20:01:26 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Rambaldi <rambaldi@xs4all.nl>, linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.27-rc5 xen balloon driver warnings
Message-ID: <20080908180126.GB29264@elte.hu>
References: <48C0F09C.1000101@xs4all.nl> <48C457DC.9050904@goop.org> <48C546B2.50108@xs4all.nl> <48C558D9.9030006@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48C558D9.9030006@goop.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-0.5 required=5.9 tests=BAYES_20 autolearn=no SpamAssassin version=3.2.3
	-0.5 BAYES_20               BODY: Bayesian spam probability is 5 to 20%
	[score: 0.0729]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> Rambaldi wrote:
> > I used the complete patch, I had some compile warnings.
> 
> Well, the compile warning are bad news.  Just use the first hunk.
> 
> Ingo, could you send this up to Linus?  It's a subset of a patch you've
> already got in your tree.

i cherry-picked the whole thing as that's the tested commit. Is that 
fine too?

	Ingo
