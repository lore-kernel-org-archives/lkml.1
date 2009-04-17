Return-Path: <linux-kernel-owner+w=401wt.eu-S1759723AbZDQBBp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759723AbZDQBBp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 21:01:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755648AbZDQBBg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 21:01:36 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:44253 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754912AbZDQBBf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 21:01:35 -0400
Message-Id: <20090417003755.276959950@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Thu, 16 Apr 2009 20:37:55 -0400
From: mathieu.desnoyers@polymtl.ca
To: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: [patch 0/3] Tracepoints kill rcupdate header dependency (v2)
X-Poly-FromMTA: (test.casi.polymtl.ca [132.207.72.60]) at Fri, 17 Apr 2009 01:01:17 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use rcupdate_types.h rather than rcupdate_defines.h to follow standard style.

Mathieu

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
