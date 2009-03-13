Return-Path: <linux-kernel-owner+w=401wt.eu-S1751678AbZCMHmY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751678AbZCMHmY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 03:42:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752170AbZCMHmN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 03:42:13 -0400
Received: from ti-out-0910.google.com ([209.85.142.188]:51352 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751260AbZCMHmM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 03:42:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=KLhQTPNcxwNVb0fzOMo/KFmjOMWKl2hlWV2gxieBGPW3+P0BcAAfUGsoP+hzPn7NnH
         kc/hUtzRJ9Ow+1pf6tK0irW0LjK8X3se/hLZMqqGeDU4baOoRvqFFeHd8ZcSXmeZwUe5
         tC3s4MaZkfW4RuloyhK7ZuLEqgf8LOfCtnVtI=
Date: Fri, 13 Mar 2009 15:42:32 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Renzo Davoli <renzo@cs.unibo.it>
Cc: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>,
       linux-kernel@vger.kernel.org, Jeff Dike <jdike@addtoit.com>,
       user-mode-linux-devel@lists.sourceforge.net,
       Roland McGrath <roland@redhat.com>
Subject: Re: [PATCH 0/2] ptrace_vm: ptrace for syscall emulation virtual
	machines
Message-ID: <20090313074232.GA8933@hack>
References: <20090204080236.GA17452@cs.unibo.it> <20090310214436.GC5213@cs.unibo.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090310214436.GC5213@cs.unibo.it>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 10, 2009 at 10:44:36PM +0100, Renzo Davoli wrote:
>Cong,
>
>I have updated the PTRACE_VM patches.
>The patches have been rebased to linux-2.6.29-rc7 but apply to linux-2.6.29-rc7-git3.
>
>The set is composed by two patches.
>The first one is for all those architectures where PTRACE_SYSCALL is
>managed via tracehook (x86, powerpc etc).
>Given the wonderful work by Roland McGrath this patch is now
>architecture independent and straightforward simple.
>
>The second one is the support of PTRACE_VM for user-mode-linux.
>It provides PTRACE_VM for UML processes and uses PTRACE_VM of the hosting 
>kernel.
>

Hello, Renzo!

Thanks very much for your patches!

I am sorting these, give me some more time, since I am not so familiar
with ptrace. :^)

And also let's Cc Roland to see if we can get any feedbacks from him.

Thanks.

-- 
Do what you love, f**k the rest! F**k the regulations!
 
