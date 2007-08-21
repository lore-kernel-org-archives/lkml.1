Return-Path: <linux-kernel-owner+w=401wt.eu-S932086AbXHUPfw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932086AbXHUPfw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 11:35:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759345AbXHUPfn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 11:35:43 -0400
Received: from web36611.mail.mud.yahoo.com ([209.191.85.28]:44733 "HELO
	web36611.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1760589AbXHUPfn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 11:35:43 -0400
X-YMail-OSG: NaFKvAoVM1k7jtFZ8A9QnqXZLT1Tm0okYv38sa4r6nel9yaT
X-RocketYMMF: rancidfat
Date: Tue, 21 Aug 2007 08:35:40 -0700 (PDT)
From: Casey Schaufler <casey@schaufler-ca.com>
Reply-To: casey@schaufler-ca.com
Subject: Re: [PATCH] Smack: Simplified Mandatory Access Control Kernel
To: Pavel Machek <pavel@ucw.cz>, Casey Schaufler <casey@schaufler-ca.com>
Cc: Kyle Moffett <mrmacman_g4@mac.com>, linux-security-module@vger.kernel.org,
       LKML Kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20070821073710.GB7258@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <497654.62822.qm@web36611.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--- Pavel Machek <pavel@ucw.cz> wrote:

> Hi!
> 
> > > Ergo the only  
> > > people who should be writing security policy for deployment are those  
> > > people who have studied and trained in the stuff.  Those people are  
> > > also known as "security professionals".
> > 
> > If only security professionals can use the system you have failed
> > to provide a general purpose facility. It may have value in limited
> > circumstances but it is not for everybody.
> 
> But that's okay. Maybe SElinux is not simple enough to use for
> everyone, but that does not mean you can't auto-generate policy from
> something else, "easy to understand". IOW smack may be great idea,

Thank you.

> but you written it in wrong language. You
> written it in C, while you should have written it in SELinux policy
> language (and your favourite scripting language as frontend).

I have often marvelled at the notion of a simplification layer.
I believe that you build complex things on top of simple things,
not the other way around.


Casey Schaufler
casey@schaufler-ca.com
