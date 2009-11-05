Return-Path: <linux-kernel-owner+w=401wt.eu-S1753625AbZKEHWZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753625AbZKEHWZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 02:22:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751051AbZKEHWY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 02:22:24 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:48187
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750825AbZKEHWX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 02:22:23 -0500
Date: Wed, 04 Nov 2009 23:22:49 -0800 (PST)
Message-Id: <20091104.232249.231355554.davem@davemloft.net>
To: gilad@codefidence.com
Cc: Valdis.Kletnieks@vt.edu, ilpo.jarvinen@helsinki.fi, eric.dumazet@gmail.com,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, ori@comsleep.com
Subject: Re: 2.6.32-rc5-mmotm1101 - kernel BUG at net/ipv4/tcp_input.c:3707!
From: David Miller <davem@davemloft.net>
In-Reply-To: <4AF1AF28.2030106@codefidence.com>
References: <Pine.LNX.4.64.0911032330090.3488@melkinkari.cs.Helsinki.FI>
	<7916.1257300093@turing-police.cc.vt.edu>
	<4AF1AF28.2030106@codefidence.com>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gilad Ben-Yossef <gilad@codefidence.com>
Date: Wed, 04 Nov 2009 18:43:20 +0200

> Kindly try the next patch. It goes on top (in addition to) the
> previous one. This should fix the crash.

Ok, now I know that both patches need to go in, I'll apply
the other one too.

Forget about my confusion in my other reply.
