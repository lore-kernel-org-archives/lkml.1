Return-Path: <linux-kernel-owner+w=401wt.eu-S1753552AbZKLRTk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753552AbZKLRTk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 12:19:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753441AbZKLRTk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 12:19:40 -0500
Received: from relay2.sgi.com ([192.48.179.30]:44328 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753454AbZKLRTj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 12:19:39 -0500
Message-Id: <20091112171934.584037000@alcatraz.americas.sgi.com>
User-Agent: quilt/0.46-1
Date: Thu, 12 Nov 2009 11:19:34 -0600
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>,
       Roland Dreier <rdreier@cisco.com>, Randy Dunlap <rdunlap@xenotime.net>,
       Tejun Heo <tj@kernel.org>, Andi Kleen <andi@firstfloor.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, Yinghai Lu <yhlu.kernel@gmail.com>,
       "H. Peter Anvin" <hpa@zytor.com>, David Rientjes <rientjes@google.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       Jack Steiner <steiner@sgi.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, x86@kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 0/7] Limit console output by suppressing repetitious messages
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Second version...

-- 
