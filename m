Return-Path: <linux-kernel-owner+w=401wt.eu-S1758282AbYEOD7a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758282AbYEOD7a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 23:59:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754449AbYEOD7V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 23:59:21 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:47669 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752922AbYEOD7U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 23:59:20 -0400
Message-Id: <20080515034942.109223655@goodmis.org>
User-Agent: quilt/0.46-1
Date: Wed, 14 May 2008 23:49:42 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, pq@iki.fi, proski@gnu.org,
       sandmann@redhat.com, a.p.zijlstra@chello.nl, linuxppc-dev@ozlabs.org,
       paulus@samba.org, benh@kernel.crashing.org
Subject: [PATCH 0/2] ftrace ported to PPC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The following two patches ports ftrace to PowerPC. I tested this on
both my PPC64 box as well as my 32bit PowerBook G4.

This applies to the latest sched-devel (with some extra hacks to get that
to boot on PPC).

This also depends on the CFLAGS_REMOVE_foo.o patches I sent earlier.

-- Steve

