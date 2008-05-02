Return-Path: <linux-kernel-owner+w=401wt.eu-S933700AbYEBKVt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933700AbYEBKVt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 06:21:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759296AbYEBKVi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 06:21:38 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:33192 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1762513AbYEBKVh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 06:21:37 -0400
Date: Fri, 2 May 2008 11:12:33 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: WANG Cong <xiyou.wangcong@gmail.com>
Cc: linux-kernel@vger.kernel.org, jdike@addtoit.com,
       user-mode-linux-devel@lists.sourceforge.net, akpm@linux-foundation.org
Subject: Re: [Patch] UML: Fix inconsistence due to tty_operation change
Message-ID: <20080502111233.66ea9428@core>
In-Reply-To: <alpine.LFD.1.10.0805021450260.3349@localhost.localdomain>
References: <alpine.LFD.1.10.0805021450260.3349@localhost.localdomain>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2 May 2008 14:59:46 +0800 (CST)
WANG Cong <xiyou.wangcong@gmail.com> wrote:

> 
> 'put_char' of 'struct tty_operations' has changed from 'void' into 'int'.
> This can also shut up comipler warnings.
> 
> Cc: Jeff Dike <jdike@addtoit.com>
> Signed-off-by: WANG Cong <wangcong@zeuux.org>

Acked-by: Alan Cox <alan@redhat.com>

