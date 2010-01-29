Return-Path: <linux-kernel-owner+w=401wt.eu-S1756734Ab0A2Hzz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756734Ab0A2Hzz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 02:55:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756726Ab0A2Hzx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 02:55:53 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:37931 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756725Ab0A2Hzw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 02:55:52 -0500
Date: Fri, 29 Jan 2010 08:55:25 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: eranian@google.com, linux-kernel@vger.kernel.org,
       Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH 0/4] perf x86 fixes
Message-ID: <20100129075525.GI14636@elte.hu>
References: <20100127220745.027096123@chello.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100127220745.027096123@chello.nl>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> These patches make the tmp.perf/core branch work for me, that is, esp.
> the first patch in this series cured a few funnies, the rest is
> basically fallout from staring at that code too long.

Thanks Peter, will have a look at getting the tmp.perf/core bits into 
tip:master today.

	Ingo
