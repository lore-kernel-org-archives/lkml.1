Return-Path: <linux-kernel-owner+w=401wt.eu-S1755622Ab0AVP7y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755622Ab0AVP7y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 10:59:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755587Ab0AVP7t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 10:59:49 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:41701 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755532Ab0AVP7m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 10:59:42 -0500
Message-Id: <20100122155044.391857484@chello.nl>
User-Agent: quilt/0.46-1
Date: Fri, 22 Jan 2010 16:50:44 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: eranian@google.com, fweisbec@gmail.com, paulus@samba.org, mingo@elte.hu,
       davem@davemloft.net, robert.richter@amd.com
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 00/10] perf/x86  queue
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is my current perf/x86 queue, after I test this lot a bit, I'll
look at stacking that AMD stuff on top.

After that I'll have a look at Roberts bits, most of that looked quite nice.

