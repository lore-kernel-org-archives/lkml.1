Return-Path: <linux-kernel-owner+w=401wt.eu-S1755241AbXLKBgw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755241AbXLKBgw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2007 20:36:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751081AbXLKBgp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Dec 2007 20:36:45 -0500
Received: from mx1.redhat.com ([66.187.233.31]:58317 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751176AbXLKBgp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2007 20:36:45 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
X-Fcc: ~/Mail/linus
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Alexey Dobriyan <adobriyan@sw.ru>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Scott James Remnant <scott@ubuntu.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm 1/2] ptrace_stop: fix the race with ptrace detach+attach
In-Reply-To: Oleg Nesterov's message of  Thursday, 22 November 2007 19:14:59 +0300 <20071122161459.GA5973@tv-sign.ru>
References: <20071122161459.GA5973@tv-sign.ru>
X-Antipastobozoticataclysm: Bariumenemanilow
Message-Id: <20071211013639.D540F26F997@magilla.localdomain>
Date: Mon, 10 Dec 2007 17:36:39 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Your change looks correct to me.


Thanks,
Roland
