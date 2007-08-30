Return-Path: <linux-kernel-owner+w=401wt.eu-S1761430AbXH3A0p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761430AbXH3A0p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2007 20:26:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756842AbXH3A0f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Aug 2007 20:26:35 -0400
Received: from h151.mvista.com ([63.81.120.158]:34289 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1755045AbXH3A0e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2007 20:26:34 -0400
Subject: 2.6.23-rc4-dw1
From: Daniel Walker <dwalker@mvista.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, mingo@redhat.com, linux-rt-users@vger.kernel.org,
       Steven Rostedt <rostedt@goodmis.org>,
       Sven-Thorsten Dietrich <sdietrich@novell.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Content-Type: text/plain
Date: Wed, 29 Aug 2007 17:17:29 -0700
Message-Id: <1188433049.26038.15.camel@dhcp193.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-2.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


I've updated to 2.6.23-rc4 .. This is an "Ingo appears to be busy.."
release .. I've been waiting for a -rt update , but there hasn't been
one for a while. So my tree is the best everyone will get for now.

ftp://source.mvista.com/pub/dwalker/rt/patch-2.6.23-rc4-dw1
ftp://source.mvista.com/pub/dwalker/rt/patch-2.6.23-rc4-dw1.tar.bz2

The patches follow the release style of Ingo's tree, and his release
notes also apply to my patch as well.

I included a fresh git-acpi pull. I also included all the patches I've
submitted to Ingo, and the following patches that got submitting to lkml
and the linux-rt-users list,

From: Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH RT] fix non SMP compile smp stubs

From: Sven-Thorsten Dietrich <sdietrich@novell.com>
Subject: [PATCH RT] - Mellanox IB driver patch

From: Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH RT] Add missing semicolon in percpu_list.h

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH RFC -rt] synchronize_sched() without migration

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH RFC -rt] Allow rcutorture to handle synchronize_sched()

From: Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH RT] Only run softirqs from the irq thread if the irq

From: Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH RT 2/3] initialize the clock source to jiffies clock.

Enjoy,

Daniel

