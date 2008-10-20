Return-Path: <linux-kernel-owner+w=401wt.eu-S1753489AbYJTQwb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753489AbYJTQwb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 12:52:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753383AbYJTQwL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 12:52:11 -0400
Received: from mx1.redhat.com ([66.187.233.31]:35923 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752751AbYJTQwJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 12:52:09 -0400
Date: Mon, 20 Oct 2008 12:51:01 -0400
From: Neil Horman <nhorman@redhat.com>
To: Alexander van Heukelum <heukelum@mailshack.com>
Cc: Neil Horman <nhorman@tuxdriver.com>,
       Alexander van Heukelum <heukelum@fastmail.fm>,
       akpm@linux-foundation.org, kexec@lists.infradead.org,
       linux-kernel@vger.kernel.org, hbabu@us.ibm.com, mingo@redhat.com,
       ebiederm@xmission.com, hpa@zytor.com, Ingo Molnar <mingo@elte.hu>,
       tglx@linutronix.de, vgoyal@redhat.com
Subject: Re: [PATCH] x86, dumpstack: some more unification
Message-ID: <20081020165101.GC13856@hmsendeavour.rdu.redhat.com>
References: <20081017210013.GD23591@hmsreliant.think-freely.org> <20081020121339.GE10594@elte.hu> <20081020134211.GA15574@hmsreliant.think-freely.org> <20081020150731.GA25999@mailshack.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081020150731.GA25999@mailshack.com>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 20, 2008 at 05:07:31PM +0200, Alexander van Heukelum wrote:
> Hi Ingo, Neil,
> 
> Doing more unification of dumpstack is/was on my
> TODO list, but it got sidetracked with some other
> hobby projects.
> 
> I did unify oops_begin, oops_end, die and die_nmi,
> and it seems to work. It needs more careful testing,
> I think, but if someone (Neil?) wants to take a
> look and validate the result...
> 
> Greetings,
>     Alexander
> 
Please send me the patch, If/when I get a few moments, I'd be happy to give it a
spin here.  

Thanks!
Neil

> _______________________________________________
> kexec mailing list
> kexec@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/kexec

-- 
/***************************************************
 *Neil Horman
 *Senior Software Engineer
 *Red Hat, Inc.
 *nhorman@redhat.com
 *gpg keyid: 1024D / 0x92A74FA1
 *http://pgp.mit.edu
 ***************************************************/
