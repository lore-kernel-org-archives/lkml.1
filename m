Return-Path: <linux-kernel-owner+w=401wt.eu-S1762048AbZEOKxo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762048AbZEOKxo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 06:53:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760893AbZEOKxh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 06:53:37 -0400
Received: from e28smtp07.in.ibm.com ([59.145.155.7]:51288 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760545AbZEOKxg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 06:53:36 -0400
Date: Fri, 15 May 2009 16:23:31 +0530
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
Message-ID: <20090515105331.GA21581@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,
        Please find a new patchset that implements generic Hardware Breakpoint
interfaces and an implementation for x86/x86_64 architecture. The patches have
undergone several changes since their last submission to you and is more refined
now.

Kindly accept them to be a part of -tip tree.

Thanks,
K.Prasad

