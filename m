Return-Path: <linux-kernel-owner+w=401wt.eu-S1754585AbYFDRIx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754585AbYFDRIx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 13:08:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754218AbYFDRIE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 13:08:04 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:47546 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752443AbYFDRIA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 13:08:00 -0400
Date: Wed, 4 Jun 2008 21:09:04 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Cc: Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Matthew Wilcox <matthew@wil.cx>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] introduce signal_pending_state()
Message-ID: <20080604170904.GA10270@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The second patch is just an example of how the new helper can be used
(besides for schedule).

Oleg.

