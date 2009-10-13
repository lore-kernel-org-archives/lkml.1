Return-Path: <linux-kernel-owner+w=401wt.eu-S933601AbZJMHPL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933601AbZJMHPL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 03:15:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933105AbZJMHPJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 03:15:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33081 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758917AbZJMHPH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 03:15:07 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <817ecb6f0910121803p52a4049ep4a712545d28bba76@mail.gmail.com>
References: <817ecb6f0910121803p52a4049ep4a712545d28bba76@mail.gmail.com>
To: Siarhei Liakh <sliakh.lkml@gmail.com>
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org,
       Arjan van de Ven <arjan@infradead.org>,
       James Morris <jmorris@namei.org>,
       Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@muc.de>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@elte.hu>, Aristeu Rozanski <aris@redhat.com>
Subject: Re: [PATCH V5] x86: NX protection for kernel data
Date: Tue, 13 Oct 2009 08:14:06 +0100
Message-ID: <10109.1255418046@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Siarhei Liakh <sliakh.lkml@gmail.com> wrote:

> @@ -440,11 +441,29 @@ void free_init_pages(char *what, unsigned long
> begin, unsigned long end)

Your mail client is word wrapping your patches.

David
