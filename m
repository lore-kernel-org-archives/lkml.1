Return-Path: <linux-kernel-owner+w=401wt.eu-S1755607AbZLRTxR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755607AbZLRTxR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 14:53:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751703AbZLRTxN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 14:53:13 -0500
Received: from mx1.redhat.com ([209.132.183.28]:10963 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755550AbZLRTxK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 14:53:10 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Masami Hiramatsu <mhiramat@redhat.com>
X-Fcc: ~/Mail/linus
Cc: Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
       Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [PATCH BUGFIX] [RESEND] mm: Pass mm->flags as a coredump parameter
	for consistency
In-Reply-To: Masami Hiramatsu's message of  Friday, 18 December 2009 11:50:06 -0500 <20091218165006.18457.52191.stgit@dhcp-100-2-132.bos.redhat.com>
References: <20091218165006.18457.52191.stgit@dhcp-100-2-132.bos.redhat.com>
Emacs: don't cry -- it won't help.
Message-Id: <20091218195202.BD1CBF99A@magilla.sf.frob.com>
Date: Fri, 18 Dec 2009 11:52:02 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Roland McGrath <roland@redhat.com>
