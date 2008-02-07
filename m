Return-Path: <linux-kernel-owner+w=401wt.eu-S1754773AbYBGP4k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754773AbYBGP4k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 10:56:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754240AbYBGP4d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 10:56:33 -0500
Received: from el-out-1112.google.com ([209.85.162.183]:14336 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752319AbYBGP4b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 10:56:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:x-x-sender:reply-to:to:cc:subject:in-reply-to:message-id:references:user-agent:mime-version:content-type;
        b=kQOamtU9POPy7gExEFSRJWRf4nCEdj/QLTEbZfrytXCfCAcTsQ5F4w7DBIiyG7qWXk1V6qyuDJaCzWHQdIHGEJc19LnWfj9cgOfHqItiTFcGGwAHF6khd4mj/tsDdMMqVMHns3lfl62SOWOcLgMLjXCgPtN7kbYpa+mktJl2nk4=
Date: Thu, 7 Feb 2008 10:56:16 -0500 (EST)
From: Parag Warudkar <parag.warudkar@gmail.com>
X-X-Sender: parag@mini.warudkars.net
Reply-To: parag.warudkar@gmail.com
To: =?ISO-8859-15?Q?Alejandro_Riveira_Fern=E1ndez?= 
	<ariveira@gmail.com>
cc: Frank Mayhar <fmayhar@google.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       bugme-daemon@bugzilla.kernel.org, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Roland McGrath <roland@redhat.com>, Jakub Jelinek <jakub@redhat.com>
Subject: Re: [Bugme-new] [Bug 9906] New: Weird hang with NPTL and SIGPROF.
In-Reply-To: <alpine.LRH.1.00.0802071040010.29320@mini.warudkars.net>
Message-ID: <alpine.LRH.1.00.0802071054160.29320@mini.warudkars.net>
References: <bug-9906-10286@http.bugzilla.kernel.org/> <20080206165045.89b809cc.akpm@linux-foundation.org> <1202345893.8525.33.camel@peace.smo.corp.google.com> <alpine.LRH.1.00.0802062148480.7445@mini.warudkars.net> <20080207162203.3e3cf5ab@Varda>
 <alpine.LRH.1.00.0802071040010.29320@mini.warudkars.net>
User-Agent: Alpine 1.00 (LRH 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 7 Feb 2008, Parag Warudkar wrote:

>    x86_64+SMP+PREEMPT+GnuC-4.1.2+Glibc-2.5 = Reproducible.	
> 
That should of course be   
 x86_64+SMP+PREEMPT+GnuC-4.1.3+Glibc-2.6.1 = Reproducible.	

