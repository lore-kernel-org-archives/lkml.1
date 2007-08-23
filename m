Return-Path: <linux-kernel-owner+w=401wt.eu-S1765284AbXHWPzk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765284AbXHWPzk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 11:55:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763426AbXHWPzZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 11:55:25 -0400
Received: from mail.sgg.ru ([217.23.135.1]:52167 "EHLO mail.sgg.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765059AbXHWPzY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 11:55:24 -0400
Date: Thu, 23 Aug 2007 19:58:25 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Dave Airlie <airlied@redhat.com>, Roland McGrath <roland@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: What does drm do with signals?
Message-ID: <20070823155825.GA1536@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Could someone please explain why do we need block_all_signals() ?

I can't understand what was the intended behaviour, but anyway
I suspect it doesn't work as expected.

Oleg.

