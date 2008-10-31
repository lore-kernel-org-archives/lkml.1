Return-Path: <linux-kernel-owner+w=401wt.eu-S1752702AbYJaPYP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752702AbYJaPYP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2008 11:24:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751450AbYJaPX6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Oct 2008 11:23:58 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:60559 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751267AbYJaPX6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2008 11:23:58 -0400
Date: Fri, 31 Oct 2008 11:23:56 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Ingo Molnar <mingo@elte.hu>
cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>
Subject: schedule tracing
Message-ID: <alpine.DEB.1.10.0810311122540.20404@gandalf.stny.rr.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

Tracing the schedule is very useful. Do we still need this:

CFLAGS_REMOVE_sched.o = -mno-spe -pg

in kernel/Makefile?

-- Steve


