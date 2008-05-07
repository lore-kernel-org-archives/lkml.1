Return-Path: <linux-kernel-owner+w=401wt.eu-S933453AbYEGABv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933453AbYEGABv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 20:01:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760277AbYEGABi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 20:01:38 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:33636 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755167AbYEGABh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 20:01:37 -0400
X-AuthUser: davidel@xmailserver.org
Date: Tue, 6 May 2008 17:01:33 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Ulrich Drepper <drepper@redhat.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Michael Kerrisk <mtk.manpages@googlemail.com>,
       Matthew Helsley <matthltc@us.ibm.com>
Subject: Re: [PATCH] flag parameters add-on: remove epoll_create size param
In-Reply-To: <200805062336.m46NaXvw008006@devserv.devel.redhat.com>
Message-ID: <Pine.LNX.4.64.0805061658090.25162@alien.or.mcafeemobile.com>
References: <200805062336.m46NaXvw008006@devserv.devel.redhat.com>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 May 2008, Ulrich Drepper wrote:

> This patch is to be applied on top of the series which adds the flag
> parameters.  It removes the size parameter from the new epoll_create
> syscall and renames the syscall itself.  The updated test program
> follows.
> 
> Signed-off-by: Ulrich Drepper <drepper@redhat.com>

We're driving Uli crazy :)
Thank you Matthew and Michael for noticing this before it went in.

Acked-by: Davide Libenzi <davidel@xmailserver.org>



- Davide


