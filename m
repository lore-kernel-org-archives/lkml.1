Return-Path: <linux-kernel-owner+w=401wt.eu-S1754049AbZBICO5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754049AbZBICO5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Feb 2009 21:14:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753491AbZBICOt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Feb 2009 21:14:49 -0500
Received: from mx1.redhat.com ([66.187.233.31]:52253 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753465AbZBICOs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Feb 2009 21:14:48 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
X-Fcc: ~/Mail/linus
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Jerome Marchand <jmarchan@redhat.com>,
       Denys Vlasenko <dvlasenk@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] ptrace: reintroduce __ptrace_detach() as a callee
	of ptrace_exit()
In-Reply-To: Oleg Nesterov's message of  Thursday, 5 February 2009 23:06:56 +0100 <20090205220656.GA7660@redhat.com>
References: <20090129042920.GA5111@redhat.com>
	<20090205012334.9E60FFC381@magilla.sf.frob.com>
	<20090205143959.GA20953@redhat.com>
	<20090205203731.1E02BFC381@magilla.sf.frob.com>
	<20090205220656.GA7660@redhat.com>
X-Shopping-List: (1) Gigantic mispronunciation rectractors
   (2) Titanic aggressors
   (3) Malcontent pistons
   (4) Platonic bag lunches
Message-Id: <20090209021435.7D80FFC330@magilla.sf.frob.com>
Date: Sun,  8 Feb 2009 18:14:35 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> (And I still hope we can change the rules sometimes, I think there
>  is no good reason to have task_detached() or EXIT_DEAD tasks on
>  ->children list. But this is offtopic.)

Agreed on both counts. :-)


Thanks,
Roland
