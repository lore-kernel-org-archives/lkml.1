Return-Path: <linux-kernel-owner+w=401wt.eu-S1761184AbXGJQgb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761184AbXGJQgb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 12:36:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756152AbXGJQgY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 12:36:24 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:52738 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755376AbXGJQgX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 12:36:23 -0400
Subject: Re: [PATCH] LinuxPPS (with new syscalls API) - new version
From: David Woodhouse <dwmw2@infradead.org>
To: Rodolfo Giometti <giometti@enneenne.com>
Cc: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20070710163625.GH32503@enneenne.com>
References: <20070628161450.GD13886@enneenne.com>
	 <1183117082.1170.308.camel@pmac.infradead.org>
	 <20070629150813.GM13886@enneenne.com>
	 <1183132548.1170.360.camel@pmac.infradead.org>
	 <20070629163422.GP13886@enneenne.com>
	 <1183135253.17622.5.camel@shinybook.infradead.org>
	 <20070630171340.GT13886@enneenne.com>
	 <20070701171325.29d8b184.sfr@canb.auug.org.au>
	 <20070701192441.GW13886@enneenne.com>
	 <20070710160151.GB31195@csclub.uwaterloo.ca>
	 <20070710163625.GH32503@enneenne.com>
Content-Type: text/plain
Date: Tue, 10 Jul 2007 17:36:16 +0100
Message-Id: <1184085376.32628.18.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 (2.10.2-2.fc7.dwmw2.1) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-07-10 at 18:36 +0200, Rodolfo Giometti wrote:
> Sorry I wrote wrong. I meant __u32.

We guessed that much.

> I can use __u64 for seconds but doing this there could be problems for
> 32 bits platforms? =:-o

Why would there be problems?

-- 
dwmw2

