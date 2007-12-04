Return-Path: <linux-kernel-owner+w=401wt.eu-S1752944AbXLDK2i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752944AbXLDK2i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 05:28:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751248AbXLDK2b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 05:28:31 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:44770 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751216AbXLDK2a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 05:28:30 -0500
Date: Tue, 4 Dec 2007 11:28:02 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Thomas <gimpel@sonnenkinder.org>
Cc: linux-kernel@vger.kernel.org, Fengguang Wu <wfg@mail.ustc.edu.cn>,
       Peter Zijlstra <peterz@infradead.org>, bugme-daemon@bugzilla.kernel.org
Subject: [Bug 9291] pdflush stuck in D state with v2.6.24-rc1-192-gef49c32
Message-ID: <20071204102802.GA14490@elte.hu>
References: <20071031175318.GU25561@iucha.net> <E1InUH6-0001vE-1Y@localhost> <20071101122558.GX25561@iucha.net> <E1InZht-0004lr-NN@localhost> <20071101141414.GZ25561@iucha.net> <E1InlPV-0001f1-SL@localhost> <20071102021002.GF25561@iucha.net> <E1Inw51-0001e8-PS@localhost> <20071102133239.GI25561@iucha.net> <loom.20071111T133858-314@post.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <loom.20071111T133858-314@post.gmane.org>
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


* Thomas <gimpel@sonnenkinder.org> wrote:

> I can confirm this issue too on any .24-rc. I'm also using reiserfs on 
> a LVM.
> 
> And there is one more user on Gentoo forums having the same issue. 
> http://forums.gentoo.org/viewtopic-t-612959.html
> 
> So you are not alone, florian.

any progress on this issue? Seems a bit stalled.

	Ingo
