Return-Path: <linux-kernel-owner+w=401wt.eu-S1755348AbXIDXfX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755348AbXIDXfX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2007 19:35:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754651AbXIDXfK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Sep 2007 19:35:10 -0400
Received: from main.gmane.org ([80.91.229.2]:55637 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754568AbXIDXfI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2007 19:35:08 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Steve Reinhardt <stever@gmail.com>
Subject: Re: 2.6.22.5 forcedeth timeout hang
Date: Tue, 4 Sep 2007 23:32:19 +0000 (UTC)
Message-ID: <loom.20070905T012627-145@post.gmane.org>
References: <46CE1CC7.6000507@exegy.com> <20070824050617.GS6002@1wt.eu> <46CEC083.2010708@exegy.com> <20070824115108.GA28737@1wt.eu> <46CECCAF.8050907@exegy.com> <20070824121459.GB28737@1wt.eu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@sea.gmane.org
X-Gmane-NNTP-Posting-Host: main.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 71.56.128.56 (Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.8.1.6) Gecko/20070725 Firefox/2.0.0.6)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


We're seeing this identical timeout starting with 2.6.21, any time we try and
push a significant amount of traffic through the nforce ethernet.  We've rolled
back to 2.6.20.18 and don't see any problems.  It seems that this bug got
introduced along with all the forcedeth fixes and optimizations in 2.6.21.

Steve



