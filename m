Return-Path: <linux-kernel-owner+w=401wt.eu-S1762458AbZJOInL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762458AbZJOInL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 04:43:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761606AbZJOInK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 04:43:10 -0400
Received: from www.tglx.de ([62.245.132.106]:54999 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760204AbZJOInK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 04:43:10 -0400
Message-Id: <20091015083906.716130653@linutronix.de>
User-Agent: quilt/0.47-1
Date: Thu, 15 Oct 2009 08:42:11 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Arnd Bergmann <arnd@arndb.de>,
       ALan Cox <alan@lxorguk.ukuu.org.uk>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [patch 0/7] BKL the next lot
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I started to go through Arnds list of ioctls.

Please review / comment.

Thanks,

	tglx



