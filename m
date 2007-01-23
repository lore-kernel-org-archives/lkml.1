Return-Path: <linux-kernel-owner+w=401wt.eu-S965450AbXAWT6N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965450AbXAWT6N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jan 2007 14:58:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965451AbXAWT6N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jan 2007 14:58:13 -0500
Received: from mx1.redhat.com ([66.187.233.31]:45509 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965450AbXAWT6M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jan 2007 14:58:12 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Andrew Morton <akpm@osdl.org>
X-Fcc: ~/Mail/linus
Cc: Linus Torvalds <torvalds@osdl.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/11] i386 vDSO: use VM_ALWAYSDUMP
In-Reply-To: Andrew Morton's message of  Tuesday, 23 January 2007 11:48:25 -0800 <20070123114825.21ebc2e3.akpm@osdl.org>
X-Shopping-List: (1) Barbaric lion confrontations
   (2) Clerical Baltic yarns
   (3) Magnetic commendations
Message-Id: <20070123195732.82D8A1800E9@magilla.sf.frob.com>
Date: Tue, 23 Jan 2007 11:57:32 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Sat, 13 Jan 2007 21:34:28 -0800 (PST)
> Roland McGrath <roland@redhat.com> wrote:
> 
> > +	     vma = vma->vm_next ?: vma == gate_vma ? NULL : gate_vma) {
> 
> Painful.   Can we do this?

Can't stand concise, eh?  ;-)  Your version is fine with me.


Thanks,
Roland
