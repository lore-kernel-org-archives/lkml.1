Return-Path: <linux-kernel-owner+w=401wt.eu-S1758819AbYFCWAk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758819AbYFCWAk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 18:00:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753251AbYFCWAa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 18:00:30 -0400
Received: from mx1.redhat.com ([66.187.233.31]:57431 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753231AbYFCWA3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 18:00:29 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
X-Fcc: ~/Mail/linus
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] signals: do_signal_stop: kill the SIGNAL_UNKILLABLE check
In-Reply-To: Oleg Nesterov's message of  Saturday, 31 May 2008 20:15:33 +0400 <20080531161533.GA5566@tv-sign.ru>
References: <20080531161533.GA5566@tv-sign.ru>
X-Windows: ignorance is our most important resource.
Message-Id: <20080603215927.EAE9226FC96@magilla.localdomain>
Date: Tue,  3 Jun 2008 14:59:27 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Roland McGrath <roland@redhat.com>
