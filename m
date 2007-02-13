Return-Path: <linux-kernel-owner+w=401wt.eu-S1750706AbXBMMwE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750706AbXBMMwE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 07:52:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751205AbXBMMwE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 07:52:04 -0500
Received: from stinky.trash.net ([213.144.137.162]:35274 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750706AbXBMMwC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 07:52:02 -0500
Message-ID: <45D1B46E.9030701@trash.net>
Date: Tue, 13 Feb 2007 13:51:58 +0100
From: Patrick McHardy <kaber@trash.net>
User-Agent: Debian Thunderbird 1.0.7 (X11/20051019)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: =?UTF-8?B?TWljaGHFgiBNaXJvc8WCYXc=?= <mirq-linux@rere.qmqm.pl>
CC: netfilter-devel@lists.netfilter.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.20 11/14] nfnetlink_log: iterator functions need	iter_state
 * only
References: <20070212003738.GA8262@rere.qmqm.pl>	<20070212202052.GA28704@rere.qmqm.pl> <20070212202200.GB28704@rere.qmqm.pl>
In-Reply-To: <20070212202200.GB28704@rere.qmqm.pl>
X-Enigmail-Version: 0.93.0.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Micha³ Miros³aw wrote:
> get_*() don't need access to seq_file - iter_state is enough for them.

Applied, thanks.
