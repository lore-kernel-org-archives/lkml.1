Return-Path: <linux-kernel-owner+w=401wt.eu-S1759374AbYE1B2E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759374AbYE1B2E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 21:28:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754325AbYE1B1v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 21:27:51 -0400
Received: from lsg.lsg.lab.novell.com ([151.155.230.1]:3889 "EHLO
	lsg.lsg.lab.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752552AbYE1B1u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 21:27:50 -0400
From: Gregory Haskins <ghaskins@novell.com>
Subject: [PATCH 0/3] sched: misc sched-devel fixes for PREEMPT_RT
To: Steven Rostedt <rostedt@goodmis.org>, linux-rt-users@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Gregory Haskins <ghaskins@novell.com>
Date: Tue, 27 May 2008 18:59:29 -0600
Message-ID: <20080528005647.4146.13252.stgit@lsg.lsg.lab.novell.com>
User-Agent: StGIT/0.13
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steven,
   The following series are patches that have been accepted by Ingo in
   sched-devel post 2.6.25.  They probably should be considered for the
   next RT release as well.  The series applies to 25.4-rt3.

Regards,
-Greg
