Return-Path: <linux-kernel-owner+w=401wt.eu-S1754470AbZESTL0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754470AbZESTL0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 15:11:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751266AbZESTLT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 15:11:19 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:49971
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750820AbZESTLS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 15:11:18 -0400
Date: Tue, 19 May 2009 12:11:16 -0700 (PDT)
Message-Id: <20090519.121116.52530205.davem@davemloft.net>
To: keil@b1-systems.de
Cc: linux-kernel@vger.kernel.org, sfr@canb.auug.org.au,
       i4ldeveloper@listserv.isdn4linux.de
Subject: Re: [PATCH 01/19] Add XHFC support for embedded Speech-Design
 board to hfcmulti
From: David Miller <davem@davemloft.net>
In-Reply-To: <81986b3e8ddbb4501dce5add2707d5dcec449a23.1242739648.git.kkeil@pingi.linux-pingi.de>
References: <cover.1242739648.git.kkeil@pingi.linux-pingi.de>
	<81986b3e8ddbb4501dce5add2707d5dcec449a23.1242739648.git.kkeil@pingi.linux-pingi.de>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I have been applying some gigaset patches into the net-next-2.6
and I would therefore suggest that you push ISDN changes bound
for the next kernel release via the networking tree as well.

In fact I'm very surprised that you're not at least CC:'ing
netdev@vger.kernel.org with these patches.  Not only would they get
review for networking specific issues they would also get your patches
tracked automatically at:

	http://patchwork.ozlabs.org/project/netdev/list/

Can you at least state how you intend to manage the ISDN changes you
queue up?  Are you going to submit them independantly and straight to
Linus or are you going to play along and get them in via my
net-next-2.6 tree in order to avoid all of the merge hassles?

Thanks.
