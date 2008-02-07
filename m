Return-Path: <linux-kernel-owner+w=401wt.eu-S1757187AbYBGQyV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757187AbYBGQyV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 11:54:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752418AbYBGQyN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 11:54:13 -0500
Received: from an-out-0708.google.com ([209.85.132.244]:45604 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752225AbYBGQyM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 11:54:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:x-x-sender:reply-to:to:cc:subject:in-reply-to:message-id:references:user-agent:mime-version:content-type;
        b=BE2NrD5i4hlgQt2eMslv95yAVAecIPOQjs+QKMdK+1V531jTmczQSjnBRi5oBSxRQW5VSlk5XasmB3pC12ZyBn3nzPaMvTq1stGyTE0QGVqejIkDwm8kxLbvqag3hyIVV8rS6woGZcj5NahAK6/GmVhdP3ivuA4L1t2oyGR0zLY=
Date: Thu, 7 Feb 2008 11:53:46 -0500 (EST)
From: Parag Warudkar <parag.warudkar@gmail.com>
X-X-Sender: parag@mini.warudkars.net
Reply-To: parag.warudkar@gmail.com
To: Parag Warudkar <parag.warudkar@gmail.com>
cc: =?ISO-8859-15?Q?Alejandro_Riveira_Fern=E1ndez?= 
	<ariveira@gmail.com>,
       Frank Mayhar <fmayhar@google.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       bugme-daemon@bugzilla.kernel.org, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Roland McGrath <roland@redhat.com>, Jakub Jelinek <jakub@redhat.com>
Subject: Re: [Bugme-new] [Bug 9906] New: Weird hang with NPTL and SIGPROF.
In-Reply-To: <alpine.LRH.1.00.0802071100230.29369@mini.warudkars.net>
Message-ID: <alpine.LRH.1.00.0802071153130.15220@mini.warudkars.net>
References: <bug-9906-10286@http.bugzilla.kernel.org/> <20080206165045.89b809cc.akpm@linux-foundation.org> <1202345893.8525.33.camel@peace.smo.corp.google.com> <alpine.LRH.1.00.0802062148480.7445@mini.warudkars.net> <20080207162203.3e3cf5ab@Varda>
 <alpine.LRH.1.00.0802071040010.29320@mini.warudkars.net> <alpine.LRH.1.00.0802071054160.29320@mini.warudkars.net> <20080207165455.04ec490b@Varda> <alpine.LRH.1.00.0802071100230.29369@mini.warudkars.net>
User-Agent: Alpine 1.00 (LRH 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 7 Feb 2008, Parag Warudkar wrote:
> Yep. I will enable PREEMPT and see if it reproduces for me.

Not reproducible with PREEMPT either. 

Parag
