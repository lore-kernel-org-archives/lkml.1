Return-Path: <linux-kernel-owner+w=401wt.eu-S1752813AbXLENf7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752813AbXLENf7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 08:35:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751878AbXLENfv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 08:35:51 -0500
Received: from z2.cat.iki.fi ([212.16.98.133]:45634 "EHLO z2.cat.iki.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751493AbXLENfv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 08:35:51 -0500
Date: Wed, 5 Dec 2007 15:35:45 +0200
From: Matti Aarnio <matti.aarnio@zmailer.org>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Does vger.kernel.org automatically drop spams?
Message-ID: <20071205133545.GV6372@mea-ext.zmailer.org>
References: <200712052225.IHJ09818.MQLtJOFOSFHVOF@I-love.SAKURA.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200712052225.IHJ09818.MQLtJOFOSFHVOF@I-love.SAKURA.ne.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 05, 2007 at 10:25:52PM +0900, Tetsuo Handa wrote:
> Hello.
> 
> I posted a message to netdev@vger.kernel.org,
> linux-security-module@vger.kernel.org and netfilter-devel@vger.kernel.org
> 11 hours ago, but it seems to me my message has not delivered yet.
> Usually it won't take 10 minutes to be delivered.
> So, I'm thinking my messages was dropped.
> 
> Does vger.kernel.org have spam filter and automatically drop spams?

Yes.  Yes.  And even worse: SILENTLY drop it.  The reason was:

     global taboo header: m!OJFS!

I don't recall why that was declared taboo, but it apparently bites
on References: headers..  Entirely unintentional, I assure you.

We (the postmasters) can approve your messages for posting, but it
will take a few hours that I get off work, and have time to do it.
(I need to do some additional setups, all those lists are not
in my existing majordomo password database..)


> Regards.

/Matti Aarnio -- one of  <postmaster@vger.kernel.org>
