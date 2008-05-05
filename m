Return-Path: <linux-kernel-owner+w=401wt.eu-S1755010AbYEEEyk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755010AbYEEEyk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 00:54:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752057AbYEEEya
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 00:54:30 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:54278 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751148AbYEEEy3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 00:54:29 -0400
X-AuthUser: davidel@xmailserver.org
Date: Sun, 4 May 2008 21:54:28 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Ulrich Drepper <drepper@redhat.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       netdev@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       mtk.manpages@gmail.com, Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 12/18] flag parametersi: NONBLOCK in anon_inode_getfd
In-Reply-To: <200805050342.m453gkgJ029847@devserv.devel.redhat.com>
Message-ID: <Pine.LNX.4.64.0805042154060.8307@alien.or.mcafeemobile.com>
References: <200805050342.m453gkgJ029847@devserv.devel.redhat.com>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 4 May 2008, Ulrich Drepper wrote:

> Building on the previous change to anon_inode_getfd, this patch introduces
> support for handling of O_NONBLOCK in addition to the already supported
> O_CLOEXEC.  Following patches will take advantage of this support.  As
> can be seen, the additional support for supporting this functionality is
> minimal.
> 
> Signed-off-by: Ulrich Drepper <drepper@redhat.com>

Acked-by: Davide Libenzi <davidel@xmailserver.org>



- Davide


