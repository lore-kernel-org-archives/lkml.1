Return-Path: <linux-kernel-owner+w=401wt.eu-S1752347AbYKLI7L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752347AbYKLI7L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 03:59:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751484AbYKLI64
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 03:58:56 -0500
Received: from casper.infradead.org ([85.118.1.10]:37491 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751368AbYKLI64 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 03:58:56 -0500
Subject: Re: [PATCH][RFC][12+2][v3] A expanded CFQ scheduler for cgroups
From: Peter Zijlstra <peterz@infradead.org>
To: Satoshi UCHIDA <s-uchida@ap.jp.nec.com>
Cc: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       virtualization@lists.linux-foundation.org, jens.axboe@oracle.com,
       "'Ryo Tsuruta'" <ryov@valinux.co.jp>,
       "'Andrea Righi'" <righi.andrea@gmail.com>, ngupta@google.com,
       fernando@oss.ntt.co.jp, vtaras@openvz.org,
       "'Hirokazu Takahashi'" <taka@valinux.co.jp>, balbir@linux.vnet.ibm.com,
       "'Andrew Morton'" <akpm@linux-foundation.org>, menage@google.com,
       SUGAWARA Tomoyoshi <tom-sugawara@ap.jp.nec.com>,
       paolo.valente@unimore.it, Fabio Checconi <fabio@gandalf.sssup.it>
In-Reply-To: <000c01c9449e$c5bcdc20$51369460$@jp.nec.com>
References: <000c01c9449e$c5bcdc20$51369460$@jp.nec.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Wed, 12 Nov 2008 09:57:59 +0100
Message-Id: <1226480279.7685.2980.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Just wondering,.. have you lot looked at the recently posted BFQ
patches?

BFQ looks like a very promising elevator, its has tighter bounds than
CFQ and already does the cgroup thing.


