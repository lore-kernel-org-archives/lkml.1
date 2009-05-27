Return-Path: <linux-kernel-owner+w=401wt.eu-S933057AbZE0WZp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933057AbZE0WZp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 18:25:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932541AbZE0WZV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 18:25:21 -0400
Received: from mx1.redhat.com ([66.187.233.31]:47781 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761131AbZE0WZT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 18:25:19 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
X-Fcc: ~/Mail/linus
Cc: Christoph Hellwig <hch@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 8/X] ptrace: introduce ptrace_tracer() helper
In-Reply-To: Oleg Nesterov's message of  Wednesday, 27 May 2009 23:45:57 +0200 <20090527214557.GB6770@redhat.com>
References: <20090525000016.GA2239@redhat.com>
	<20090525215903.GA9113@redhat.com>
	<20090525223932.GA11508@redhat.com>
	<20090527024540.177FAFC36B@magilla.sf.frob.com>
	<20090527214557.GB6770@redhat.com>
Emacs: because editing your files should be a traumatic experience.
Message-Id: <20090527222459.9BC0EFC36B@magilla.sf.frob.com>
Date: Wed, 27 May 2009 15:24:59 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> So, I assume it is better to not use tracehook_tracer_task() and add
> another helper like this patch does.

I guess I don't think it matters one way or the other until we figure out
the rest of it.

Thanks,
Roland
