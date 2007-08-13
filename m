Return-Path: <linux-kernel-owner+w=401wt.eu-S945378AbXHMNSu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S945378AbXHMNSu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 09:18:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S970066AbXHMJDA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 05:03:00 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:58657 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S971006AbXHMJCz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 05:02:55 -0400
Date: Mon, 13 Aug 2007 11:02:54 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: david@lang.hm
cc: Paul Clements <paul.clements@steeleye.com>, Al Boldi <a1426z@gawab.com>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       netdev@vger.kernel.org, linux-raid@vger.kernel.org
Subject: Re: [RFD] Layering: Use-Case Composers (was: DRBD - what is it,
 anyways? [compare with e.g. NBD + MD raid])
In-Reply-To: <Pine.LNX.4.64.0708122016100.22470@asgard.lang.hm>
Message-ID: <Pine.LNX.4.64.0708131102310.28963@fbirervta.pbzchgretzou.qr>
References: <200708121335.17267.a1426z@gawab.com>
 <Pine.LNX.4.64.0708121325170.28963@fbirervta.pbzchgretzou.qr>
 <Pine.LNX.4.64.0708120933210.19502@asgard.lang.hm>
 <Pine.LNX.4.64.0708121901290.28963@fbirervta.pbzchgretzou.qr>
 <20070812174549.GA2915@teal.hq.k1024.org> <46BFB6BB.80406@steeleye.com>
 <Pine.LNX.4.64.0708122016100.22470@asgard.lang.hm>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Aug 12 2007 20:21, david@lang.hm wrote:
>
> per the message below MD (or DM) would need to be modified to work
> reasonably well with one of the disk components being over an
> unreliable link (like a network link)

Does not dm-multipath do something like that?

> are the MD/DM maintainers interested in extending their code in this direction?
> or would they prefer to keep it simpler by being able to continue to assume
> that the raid components are connected over a highly reliable connection?

	Jan
-- 
