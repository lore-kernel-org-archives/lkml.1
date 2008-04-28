Return-Path: <linux-kernel-owner+w=401wt.eu-S965736AbYD1Qg0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965736AbYD1Qg0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 12:36:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935888AbYD1QgO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 12:36:14 -0400
Received: from g5t0007.atlanta.hp.com ([15.192.0.44]:41793 "EHLO
	g5t0007.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933669AbYD1QgN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 12:36:13 -0400
Message-ID: <4815FCF9.5060109@hp.com>
Date: Mon, 28 Apr 2008 12:36:09 -0400
From: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 0/3] Skip I/O merges when disabled
References: <480F8936.5030406@hp.com> <20080424070923.GQ12774@kernel.dk> <48107891.5000308@hp.com> <20080425083809.GG12774@kernel.dk> <4811BDBB.8010604@hp.com> <4811CBBC.4000206@hp.com>
In-Reply-To: <4811CBBC.4000206@hp.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens -

Would you consider taking in a patch set that had the tunable + enabled
one-hit cache tries only? I don't see where the back-merge attempts add
anything in a truly random case.

Thanks,
Alan
