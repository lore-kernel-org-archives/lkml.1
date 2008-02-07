Return-Path: <linux-kernel-owner+w=401wt.eu-S1759271AbYBGP7t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759271AbYBGP7t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 10:59:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754792AbYBGP7l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 10:59:41 -0500
Received: from ug-out-1314.google.com ([66.249.92.173]:46031 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754568AbYBGP7k convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 10:59:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer:mime-version:content-type:content-transfer-encoding;
        b=jhfr3PHleNN8EQ5gaz1DOAvKBwla9WinOIy1BOrLONwHZJAvonQ+U5/u7ymyeJf40JsQn7yeWkZMCob93CiWbQ+2STCevoPiNBOdty3oiFbqCEkR77xY/85emyB7DmxD8w+85iv7dtHh6g8pqAa0ok3jSaVEe/Kl7vsSSFbGfGU=
Date: Thu, 7 Feb 2008 16:54:55 +0100
From: Alejandro Riveira =?UTF-8?B?RmVybsOhbmRleg==?= 
	<ariveira@gmail.com>
To: parag.warudkar@gmail.com
Cc: Frank Mayhar <fmayhar@google.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       bugme-daemon@bugzilla.kernel.org, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Roland McGrath <roland@redhat.com>, Jakub Jelinek <jakub@redhat.com>
Subject: Re: [Bugme-new] [Bug 9906] New: Weird hang with NPTL and SIGPROF.
Message-ID: <20080207165455.04ec490b@Varda>
In-Reply-To: <alpine.LRH.1.00.0802071054160.29320@mini.warudkars.net>
References: <bug-9906-10286@http.bugzilla.kernel.org/>
	<20080206165045.89b809cc.akpm@linux-foundation.org>
	<1202345893.8525.33.camel@peace.smo.corp.google.com>
	<alpine.LRH.1.00.0802062148480.7445@mini.warudkars.net>
	<20080207162203.3e3cf5ab@Varda>
	<alpine.LRH.1.00.0802071040010.29320@mini.warudkars.net>
	<alpine.LRH.1.00.0802071054160.29320@mini.warudkars.net>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

El Thu, 7 Feb 2008 10:56:16 -0500 (EST)
Parag Warudkar <parag.warudkar@gmail.com> escribió:

> 
> 
> On Thu, 7 Feb 2008, Parag Warudkar wrote:
> 
> >    x86_64+SMP+PREEMPT+GnuC-4.1.2+Glibc-2.5 = Reproducible.	
> > 
> That should of course be   
>  x86_64+SMP+PREEMPT+GnuC-4.1.3+Glibc-2.6.1 = Reproducible.	
> 
>From my previous mail 

Note that i use CC=gcc-4.2 

 $gcc-4.2 --version

 gcc-4.2 (GCC) 4.2.1 (Ubuntu 4.2.1-5ubuntu4)
