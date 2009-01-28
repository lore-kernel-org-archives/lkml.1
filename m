Return-Path: <linux-kernel-owner+w=401wt.eu-S1753805AbZA1Vpj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753805AbZA1Vpj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 16:45:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751359AbZA1Vpa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 16:45:30 -0500
Received: from www.tglx.de ([62.245.132.106]:45149 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751302AbZA1Vp3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 16:45:29 -0500
Message-Id: <20090128211912.300823284@linutronix.de>
User-Agent: quilt/0.46-1
Date: Wed, 28 Jan 2009 21:28:58 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       Carsten Emde <carsten.emde@osadl.org>
Subject: [patch-rt 0/4] Bugfixes for 2.6.26-rt
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Carsten and I spent some time to decode remaining weird behaviour of
2.6.26-rt.

Mostly trivial fixes, but nasty to reproduce and decode.

Thanks,

	tglx
-- 

