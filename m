Return-Path: <linux-kernel-owner+w=401wt.eu-S1756442AbZEPAX6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756442AbZEPAX6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 20:23:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754105AbZEPAXu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 20:23:50 -0400
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:33221 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753906AbZEPAXt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 20:23:49 -0400
Date: Sat, 16 May 2009 05:53:39 +0530
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Alan Stern <stern@rowland.harvard.edu>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Benjamin Herrenschmidt <benh@au1.ibm.com>, maneesh@linux.vnet.ibm.com,
       Roland McGrath <roland@redhat.com>,
       Masami Hiramatsu <mhiramat@redhat.com>
Subject: [Patch 00/12] Hardware Breakpoint interfaces
Message-ID: <20090516002339.GA16792@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,
	Please find the patchset that introduce generic Hardware Breakpoint
interfaces and an implementation for x86/x86_64 arch. The
"Original-patch-by:" and "Reviewed-by:" fields have been added as
appropriate.

The patches are based on commit cab667c10f6b4a86787a57184f6e18459bbab7b0
of -tip tree. Kindly accept them to be a part of the tree.

Thanks,
K.Prasad

