Return-Path: <linux-kernel-owner+w=401wt.eu-S1759678AbYEPVse@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759678AbYEPVse (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 17:48:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754839AbYEPVs0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 17:48:26 -0400
Received: from one.firstfloor.org ([213.235.205.2]:53462 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753142AbYEPVsZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 17:48:25 -0400
Message-ID: <482E0125.7070701@firstfloor.org>
Date: Fri, 16 May 2008 23:48:21 +0200
From: Andi Kleen <andi@firstfloor.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20060911)
MIME-Version: 1.0
To: Mike Snitzer <snitzer@gmail.com>
CC: device-mapper development <dm-devel@redhat.com>, agk@redhat.com,
       Ric Wheeler <ric@emc.com>, Michael Tokarev <mjt@tls.msk.ru>,
       linux-kernel@vger.kernel.org
Subject: Re: [dm-devel] Re: [PATCH] Implement barrier support for single device
 DM devices
References: <20080215120821.GA8267@basil.nowhere.org>	 <20080215122002.GM29914@agk.fab.redhat.com>	 <47B58EAA.8040405@msgid.tls.msk.ru>	 <20080215142010.GA29552@one.firstfloor.org>	 <20080215141229.GB1788@agk.fab.redhat.com> <47B97E87.6040209@emc.com>	 <47B9870B.8060005@msgid.tls.msk.ru> <47B98D8A.7090506@emc.com>	 <20080219024533.GC4066@agk.fab.redhat.com> <170fa0d20805161255i31d768ceh3b15c2640f06524b@mail.gmail.com>
In-Reply-To: <170fa0d20805161255i31d768ceh3b15c2640f06524b@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Snitzer wrote:

> Given that you feel supporting barriers on single device DM targets is
> a good thing, what is the status of such support (like Andi's patch)
> making it upstream?

It's not in 2.6.26-rc2. I was also a little surprised by it missing.

-Andi
