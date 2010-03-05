Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754072Ab0CEPnO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 10:43:14 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:57539 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753858Ab0CEPnL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 10:43:11 -0500
Message-Id: <20100305153926.639506880@chello.nl>
User-Agent: quilt/0.46-1
Date: Fri, 05 Mar 2010 16:39:26 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: mingo@elte.hu, linux-kernel@vger.kernel.org
Cc: paulus@samba.org, eranian@google.com, robert.richter@amd.com,
       fweisbec@gmail.com, Arnaldo Carvalho de Melo <acme@infradead.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 0/5] PEBS and LBR fixes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With these patches PEBS also works on my Core2 machines, although
sometimes it fails to generate samples for some reason, so there's more
errata to read.

