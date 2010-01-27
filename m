Return-Path: <linux-kernel-owner+w=401wt.eu-S1756246Ab0A0WO7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756246Ab0A0WO7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 17:14:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756164Ab0A0WOB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 17:14:01 -0500
Received: from casper.infradead.org ([85.118.1.10]:52286 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756161Ab0A0WOA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 17:14:00 -0500
Message-Id: <20100127220745.027096123@chello.nl>
User-Agent: quilt/0.46-1
Date: Wed, 27 Jan 2010 23:07:45 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: mingo@elte.hu, eranian@google.com
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 0/4] perf x86 fixes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches make the tmp.perf/core branch work for me, that is, esp.
the first patch in this series cured a few funnies, the rest is
basically fallout from staring at that code too long.

-- 

