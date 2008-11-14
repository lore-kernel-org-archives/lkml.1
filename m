Return-Path: <linux-kernel-owner+w=401wt.eu-S1755872AbYKNXCo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755872AbYKNXCo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2008 18:02:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751898AbYKNXAY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Nov 2008 18:00:24 -0500
Received: from smtp.polymtl.ca ([132.207.4.11]:52192 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751807AbYKNXAT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2008 18:00:19 -0500
Message-Id: <20081114224733.364965865@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Fri, 14 Nov 2008 17:47:33 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, Linus Torvalds <torvalds@linux-foundation.org>
Subject: [patch 00/16] Markers and Tracepoints Updates for -tip
X-Poly-FromMTA: (test.casi.polymtl.ca [132.207.72.60]) at Fri, 14 Nov 2008 23:00:00 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

Those are the markers and tracepoint updates for -tip. I have put the "bugfix"
patches at the beginning (Impact: bugfix) followed by cleanups and by API
changes.

Mathieu

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
