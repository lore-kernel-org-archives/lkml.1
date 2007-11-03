Return-Path: <linux-kernel-owner+w=401wt.eu-S1756104AbXKCQgl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756104AbXKCQgl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2007 12:36:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754744AbXKCQge
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Nov 2007 12:36:34 -0400
Received: from main.gmane.org ([80.91.229.2]:46835 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754697AbXKCQgd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2007 12:36:33 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Remigiusz Modrzejewski <lkml.only@maxnet.org.pl>
Subject: Re: Policy on dual licensing?
Date: Sat, 3 Nov 2007 16:36:04 +0000 (UTC)
Message-ID: <slrnfip934.fao.lkml.only@localhost.localdomain>
References: <slrnfiopoa.9cu.lkml.only@localhost.localdomain> <m3fxzno3fr.fsf@maximus.localdomain>
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: host-ip38-174.crowley.pl
X-Posting-License: http://ppl.7thguard.net/PPL
X-Homesite: http://lrem.net/
User-Agent: slrn/0.9.8.1 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Krzysztof Halasa wrote:
> It doesn't make sense in general. Being derived from *BSD may mean
> only a tiny fragment comes from *BSD. I can't see any valid reason
> to force/ask the author to publish his/her code under BSD
> (GPL + BSD = BSD) instead of GPLv2 as used by the whole Linux.
>
> There are exceptions, of course - if you take a *BSD project and
> include it with no/minor changes it makes sense to use BSD licence,
> because we really want to cooperate, and because we don't have to
> fear "evil corporations" taking our code (because it's mostly not
> "ours").

Well, you've shown both poles, where the correct licensing decision 
seems quite obvious. But in between there lies the great gray area,
where it's not so clear. Lets say you take a BSD driver and perform
a medium sized hack, eg add a new feature and include it into Linux
kernel. Now you've got code that has been mainly of appropriate *BSD
authorship, but with a reason for them (and the "evil corporations")
to want the change ported back. The final choice *is* to be made by
the author, it's the right way to be. What I suggest is to encourage
authors to share back, best done by maintainer asking to do so just
before committing.

-- 
Remigiusz 'lRem' Modrzejewski
Contact: http://lrem.net/pages/view/about
Feel free to correct my English.

