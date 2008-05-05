Return-Path: <linux-kernel-owner+w=401wt.eu-S1754946AbYEEElE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754946AbYEEElE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 00:41:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751999AbYEEEkv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 00:40:51 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:39646 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751967AbYEEEku (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 00:40:50 -0400
X-AuthUser: davidel@xmailserver.org
Date: Sun, 4 May 2008 21:40:48 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Ulrich Drepper <drepper@redhat.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       netdev@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       mtk.manpages@gmail.com, Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 16/18] flag parameters: NONBLOCK in timerfd_create
In-Reply-To: <200805050342.m453gkae029859@devserv.devel.redhat.com>
Message-ID: <Pine.LNX.4.64.0805042139570.8307@alien.or.mcafeemobile.com>
References: <200805050342.m453gkae029859@devserv.devel.redhat.com>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 4 May 2008, Ulrich Drepper wrote:

> This patch adds support for the TFD_NONBLOCK flag to timerfd_create.  The
> additional changes needed are minimal thanks to the previous preparation.
> 
> The following test must be adjusted for architectures other than x86 and
> x86-64 and in case the syscall numbers changed.

> Signed-off-by: Ulrich Drepper <drepper@redhat.com>

Acked-by: Davide Libenzi <davidel@xmailserver.org>



- Davide


