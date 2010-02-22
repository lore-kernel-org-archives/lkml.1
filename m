Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754050Ab0BVBKD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Feb 2010 20:10:03 -0500
Received: from ozlabs.org ([203.10.76.45]:34419 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753796Ab0BVBKA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Feb 2010 20:10:00 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Dave Young <hidave.darkstar@gmail.com>
Subject: Re: [PATCH -mm 11/17] sysctl extern cleanup - module
Date: Mon, 22 Feb 2010 11:39:45 +1030
User-Agent: KMail/1.12.2 (Linux/2.6.31-19-generic; KDE/4.3.2; i686; ; )
Cc: Patrick McHardy <kaber@trash.net>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       Arjan van de Ven <arjan@linux.intel.com>,
       Herbert Xu <herbert@gondor.apana.org.au>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       James Morris <jmorris@namei.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       linux-kernel@vger.kernel.org
References: <20100221142435.GA3019@darkstar>
In-Reply-To: <20100221142435.GA3019@darkstar>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201002221139.46057.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Feb 2010 12:54:35 am Dave Young wrote:
> Extern declarations in sysctl.c should be move to their own head file,
> and then include them in relavant .c files.
> 
> Move modprobe_path extern declaration to linux/kmod.h
> Move modules_disabled extern declaration to linux/module.h
> 
> Signed-off-by: Dave Young <hidave.darkstar@gmail.com>

Acked-by: Rusty Russell <rusty@rustcorp.com.au>

Thanks!
Rusty.
-- 
Away travelling 25Feb-26Mar (6 .de + 1 .pl + 17 .lt + 2 .sg)
