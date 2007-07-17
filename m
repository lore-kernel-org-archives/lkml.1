Return-Path: <linux-kernel-owner+w=401wt.eu-S934929AbXGQPno@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934929AbXGQPno (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 11:43:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759520AbXGQPlL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 11:41:11 -0400
Received: from mx1.redhat.com ([66.187.233.31]:45487 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934591AbXGQPlK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 11:41:10 -0400
Message-Id: <20070717173428.355522000@chello.nl>
User-Agent: quilt/0.45-1
Date: Tue, 17 Jul 2007 19:34:28 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, Zach Brown <zach.brown@oracle.com>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [RFC/T PATCH 00/12] lockdep: annotate lock_page
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

These patches are only for the brave!

I have not even tried to compile without lockdep support, one can have
both pieces if it breaks :-)

--

