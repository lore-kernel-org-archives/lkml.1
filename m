Return-Path: <linux-kernel-owner+w=401wt.eu-S1755498AbZGPK5M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755498AbZGPK5M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 06:57:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755301AbZGPKyj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 06:54:39 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:58104 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755277AbZGPKyi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 06:54:38 -0400
Message-Id: <20090716104247.536695580@samba.org>
User-Agent: quilt/0.46-1
Date: Thu, 16 Jul 2009 20:42:47 +1000
From: Anton Blanchard <anton@samba.org>
To: a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
       fweisbec@gmail.com
Cc: linux-kernel@vger.kernel.org
Subject: [patch 0/5] Various perfcounter fixes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here are a few more perfcounter fixes, and one patch that changes the
call graph option to be consistent between perf record and perf report.
Perhaps I'm too late on that one, but I thought I'd give it a try :)

