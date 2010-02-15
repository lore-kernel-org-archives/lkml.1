Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754646Ab0BOEpT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Feb 2010 23:45:19 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:43039 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752975Ab0BOEpP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Feb 2010 23:45:15 -0500
Date: Mon, 15 Feb 2010 05:44:32 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Yinghai Lu <yinghai@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH 27/35] core: move early_res
Message-ID: <20100215044432.GB19287@elte.hu>
References: <1265793639-15071-1-git-send-email-yinghai@kernel.org>
 <1265793639-15071-28-git-send-email-yinghai@kernel.org>
 <20100215011615.e3d35121.sfr@canb.auug.org.au>
 <20100214170858.GA29006@elte.hu>
 <20100215104303.428fab25.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100215104303.428fab25.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> > Btw.,are you doing these cross-build tests yourself, or are you relaying 
> > the kisskb automation notifications?
> 
> Mostly they are from the kisskb builds. [...]

Note that in most cases i find them earlier than the kisskb scripts, and i 
handle those in any case, so generally there's no need for you to re-report 
them - unless you see any such bug slip into linux-next (which you shouldnt) 
or if you rely on -tip for real PowerPC testing (which you dont AFAIK).

Thanks,

	Ingo
