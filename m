Return-Path: <linux-kernel-owner+w=401wt.eu-S1030329AbXBGAWu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030329AbXBGAWu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 19:22:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030335AbXBGAWu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 19:22:50 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:56735 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030329AbXBGAWs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 19:22:48 -0500
Message-ID: <45C91BCA.3030108@pobox.com>
Date: Tue, 06 Feb 2007 19:22:34 -0500
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20070130)
MIME-Version: 1.0
To: Jay Cliburn <jacliburn@bellsouth.net>
CC: Adrian Bunk <bunk@stusta.de>, Andrew Morton <akpm@osdl.org>,
       Xiong Huang <xiong_huang@attansic.com>, Chris Snook <csnook@redhat.com>,
       Jay Cliburn <jcliburn@gmail.com>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: [RFC: -mm patch] drivers/net/atl1/: possible cleanups
References: <20070129204528.eb8d695e.akpm@osdl.org>	<20070206221229.GH27397@stusta.de> <20070206181910.4d27046a@osprey.hogchain.net>
In-Reply-To: <20070206181910.4d27046a@osprey.hogchain.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.7 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jay Cliburn wrote:
> Your patch is just a little bit out ahead of us.  Some of your suggested
> changes are already in the pipeline; we're just waiting for Jeff to
> merge netdev#atl1 into netdev#ALL.  Should be soon.


Technical note:  merging #atl1 into #ALL happens each time 
netdev-2.6.git is flushed out from my local machine.

	Jeff


