Return-Path: <linux-kernel-owner+w=401wt.eu-S1755808AbXLKBlT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755808AbXLKBlT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2007 20:41:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751304AbXLKBlL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Dec 2007 20:41:11 -0500
Received: from mx1.redhat.com ([66.187.233.31]:58455 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751081AbXLKBlK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2007 20:41:10 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
X-Fcc: ~/Mail/linus
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Scott James Remnant <scott@ubuntu.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm 4/2] ptrace_stop: fix racy nonstop_code setting
In-Reply-To: Oleg Nesterov's message of  Thursday, 22 November 2007 20:56:22 +0300 <20071122175622.GA7051@tv-sign.ru>
References: <20071122175622.GA7051@tv-sign.ru>
X-Antipastobozoticataclysm: Bariumenemanilow
Message-Id: <20071211014104.4437C26F997@magilla.localdomain>
Date: Mon, 10 Dec 2007 17:41:04 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Your change looks correct to me.


Thanks,
Roland
