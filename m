Return-Path: <linux-kernel-owner+w=401wt.eu-S1765038AbYDVTxn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765038AbYDVTxn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 15:53:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764783AbYDVTxF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 15:53:05 -0400
Received: from relay1.sgi.com ([192.48.171.29]:36410 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1764509AbYDVTxE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 15:53:04 -0400
Date: Tue, 22 Apr 2008 14:53:02 -0500
From: Dimitri Sivanich <sivanich@sgi.com>
To: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
Subject: Dynamic softlockup detection enable/disable?
Message-ID: <20080422195302.GA17549@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Is there a way to dynamically enable or disable softlockup detection, rather than having to CONFIG_DETECT_SOFTLOCKUP=n and recompile?

Dimitri
