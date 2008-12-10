Return-Path: <linux-kernel-owner+w=401wt.eu-S1756559AbYLJTNT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756559AbYLJTNT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 14:13:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754630AbYLJTNL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 14:13:11 -0500
Received: from kuber.nabble.com ([216.139.236.158]:57515 "EHLO
	kuber.nabble.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753475AbYLJTNL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 14:13:11 -0500
Message-ID: <20942054.post@talk.nabble.com>
Date: Wed, 10 Dec 2008 11:13:09 -0800 (PST)
From: Dennis Hardy <dhardy@sogetthis.com>
To: linux-kernel@vger.kernel.org
Subject: Re: CIFS regression in 2.6.27.8
In-Reply-To: <20081209212611.25fcd053@tupile.poochiereds.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Nabble-From: dhardy@sogetthis.com
References: <20900699.post@talk.nabble.com> <84144f020812081128p6d1e2a55v69996a360e7f0e8f@mail.gmail.com> <200812082112.49468.rjw@sisk.pl> <20081209154932.0952fbf3@dhcp-100-2-144.bos.redhat.com> <20924383.post@talk.nabble.com> <20081209212611.25fcd053@tupile.poochiereds.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> I could easily be wrong, but the problem you've described seems more
> likely to be a server issue. 

Gentlemen, I am heading out to get an "L" (for loser) tattooed to my
forehead.  MSFT pushed some updates for the Windows Server previously, and
when we switched to 2.6.27.8 we rebooted everything, including the Windows
Server, which activated the updates.  MSFT broke volume size reporting --
even from other Windows machines!  We should have checked this before
posting.

Please accept my deepest apologies for this -- Linux is, as always, working
great.


-- 
View this message in context: http://www.nabble.com/CIFS-regression-in-2.6.27.8-tp20900699p20942054.html
Sent from the linux-kernel mailing list archive at Nabble.com.

