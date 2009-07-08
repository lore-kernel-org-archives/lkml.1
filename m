Return-Path: <linux-kernel-owner+w=401wt.eu-S1757311AbZGHSei@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757311AbZGHSei (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 14:34:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754520AbZGHSeb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 14:34:31 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:33302 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754332AbZGHSeb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 14:34:31 -0400
Subject: Re: [PATCH 3/3] Increase lockdep limits: MAX_LOCKDEP_CHAINS_BITS
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Joao Correia <joaomiguelcorreia@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Amerigo Wang <xiyou.wangcong@gmail.com>
In-Reply-To: <a5d9929e0907070825p78c1e527ud8f8d047767f621e@mail.gmail.com>
References: <a5d9929e0907070825p78c1e527ud8f8d047767f621e@mail.gmail.com>
Content-Type: text/plain
Date: Wed, 08 Jul 2009 20:34:26 +0200
Message-Id: <1247078066.16156.15.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-07-07 at 16:25 +0100, Joao Correia wrote:
> (Applies to current Linus tree, as of 2.6.31-rc2)
> 
> A third limit becomes apparent as being too low after raising
> MAX_STACK_TRACE_ENTRIES and MAX_LOCK_DEPTH, although this one is more
> elusive to trigger.

Would this involve reloading modules a lot?

