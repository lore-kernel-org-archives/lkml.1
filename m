Return-Path: <linux-kernel-owner+w=401wt.eu-S1756263AbYFWK1J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756263AbYFWK1J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 06:27:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754243AbYFWK05
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 06:26:57 -0400
Received: from rv-out-0506.google.com ([209.85.198.235]:28432 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753578AbYFWK04 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 06:26:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=vvOFuXb4VxDXJ/bxiEMMM1kEluzwVQmun3d5ScU2mgswGPqh60YLnWSBhu+6iobN+u
         gFS0gmsZiqaYxWrPjRYDr0a8OQCBPwz5WhEFifz8SSFCBfsgNEkjCW7PBq5cVC/0NQyr
         UPiLXJ33+XZ2Ter8ImZsLNFBxCE99hrUYLjbM=
Message-ID: <19f34abd0806230326i592ba39eu837d290e21431d14@mail.gmail.com>
Date: Mon, 23 Jun 2008 12:26:55 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Stephen Rothwell" <sfr@canb.auug.org.au>,
       "Steven Rostedt" <srostedt@redhat.com>
Subject: Re: linux-next: Tree for June 23
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <19f34abd0806230323o6373015fj93a85b929545a7a8@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080623182549.b0552851.sfr@canb.auug.org.au>
	 <19f34abd0806230323o6373015fj93a85b929545a7a8@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 23, 2008 at 12:23 PM, Vegard Nossum <vegard.nossum@gmail.com> wrote:
> Testing tracer sched_switch: PASSED
> Testing tracer sysprof: PASSED
> Testing tracer ftrace: PASSED
> Testing dynamic ftrace: PASSED
> Testing tracer irqsoff: PASSED
> Testing tracer preemptoff: PASSED
> Testing tracer preemptirqsoff: <4>------------[ cut here ]------------
> WARNING: at kernel/lockdep.c:2680 check_flags+0x142/0x160()
> Pid: 2, comm: kthreadd Not tainted 2.6.26-rc6-next-20080620 #34

<-- Oops, wrong version :-(

Will try the latest one as well.


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
