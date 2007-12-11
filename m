Return-Path: <linux-kernel-owner+w=401wt.eu-S1756088AbXLKBUu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756088AbXLKBUu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2007 20:20:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755343AbXLKBUQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Dec 2007 20:20:16 -0500
Received: from mx1.redhat.com ([66.187.233.31]:48397 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754641AbXLKBUO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2007 20:20:14 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
X-Fcc: ~/Mail/linus
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm 3/3] ptrace_check_attach: remove unneeded ->signal != NULL check
In-Reply-To: Oleg Nesterov's message of  Wednesday, 21 November 2007 19:00:33 +0300 <20071121160033.GA1178@tv-sign.ru>
References: <20071121160033.GA1178@tv-sign.ru>
X-Antipastobozoticataclysm: When George Bush projectile vomits antipasto on the Japanese.
Message-Id: <20071211012010.E4B0926F997@magilla.localdomain>
Date: Mon, 10 Dec 2007 17:20:10 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This looks fine to me.

Thanks,
Roland
