Return-Path: <linux-kernel-owner+w=401wt.eu-S1755069AbXLKBpr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755069AbXLKBpr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2007 20:45:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751806AbXLKBpj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Dec 2007 20:45:39 -0500
Received: from mx1.redhat.com ([66.187.233.31]:43782 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751304AbXLKBpi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2007 20:45:38 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
X-Fcc: ~/Mail/linus
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm 1/2] wait_task_stopped: remove unneeded delay_group_leader check
In-Reply-To: Oleg Nesterov's message of  Friday, 23 November 2007 22:59:41 +0300 <20071123195941.GA163@tv-sign.ru>
References: <20071123195941.GA163@tv-sign.ru>
X-Zippy-Says: Is this an out-take from the ``BRADY BUNCH''?
Message-Id: <20071211014533.8F10E26F997@magilla.localdomain>
Date: Mon, 10 Dec 2007 17:45:33 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Your change looks correct to me.


Thanks,
Roland
