Return-Path: <linux-kernel-owner+w=401wt.eu-S1760385AbYEBDKe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760385AbYEBDKe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 23:10:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751917AbYEBDK0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 23:10:26 -0400
Received: from py-out-1112.google.com ([64.233.166.177]:16582 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750903AbYEBDKZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 23:10:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=B6vEcjzfSh0k1X+SIpisnnf2ky8///WVs1MOIJ7kd1gEjuJ7+7HqlBkry6CuPqShuarQ8eXFToQbdENVztisBbiR0rrrwXU0PIJ6ILUMzw3jmTfQfA2mwyiJ9ex+NDY915BnP5hpzAT4QCDYtj8HMPt8SNqyDLMeE5vIBRzNj34=
Subject: Re: RFC: starting a kernel-testers group for newbies
From: Josh Boyer <jwboyer@gmail.com>
To: Paul Mackerras <paulus@samba.org>
Cc: Adrian Bunk <bunk@kernel.org>, Arjan van de Ven <arjan@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, davem@davemloft.net,
       linux-kernel@vger.kernel.org, jirislaby@gmail.com,
       Steven Rostedt <rostedt@goodmis.org>
In-Reply-To: <18458.30641.838156.434563@cargo.ozlabs.ibm.com>
References: <20080429.190352.137408408.davem@davemloft.net>
	 <200804302136.58005.rjw@sisk.pl>
	 <20080430131537.1f7a0914.akpm@linux-foundation.org>
	 <alpine.LFD.1.10.0804301325260.2980@woody.linux-foundation.org>
	 <20080501003125.GM29330@cs181133002.pp.htv.fi>
	 <20080430000338.50548884@infradead.org>
	 <20080501113038.GW29330@cs181133002.pp.htv.fi>
	 <20080430072013.7c3b30b1@infradead.org>
	 <20080501132159.GC29330@cs181133002.pp.htv.fi>
	 <18458.30641.838156.434563@cargo.ozlabs.ibm.com>
Content-Type: text/plain
Date: Thu, 01 May 2008 22:10:15 -0500
Message-Id: <1209697815.2946.156.camel@vader.jdub.homelinux.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-05-02 at 12:08 +1000, Paul Mackerras wrote:
> Adrian Bunk writes:
> 
> > "Kernel oops while running kernbench and tbench on powerpc" took more 
> > than 2 months to get resolved, and we ship 2.6.25 with this regression.
> 
> That was a very subtle bug that only showed up on one particular
> powerpc machine.  I was not able to replicate it on any of the powerpc
> machines I have here.  Nevertheless, we found it and we have a fix for
> it.  I think that's an example of the process working. :)

Was it even a regression in the classical sense of the word?  Seemed
more of a latent bug that was simply never triggered before.

josh

