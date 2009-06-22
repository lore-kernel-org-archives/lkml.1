Return-Path: <linux-kernel-owner+w=401wt.eu-S1755805AbZFVUaS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755805AbZFVUaS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 16:30:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752593AbZFVUaG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 16:30:06 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:56096 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751994AbZFVUaF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 16:30:05 -0400
Date: Mon, 22 Jun 2009 22:32:25 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: David Howells <dhowells@redhat.com>
Cc: torvalds@osdl.org, akpm@linux-foundation.org, linux-am33-list@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] LDSCRIPT: Name INIT_RAM_FS consistently
Message-ID: <20090622203225.GA12650@uranus.ravnborg.org>
References: <20090622143231.3927.1495.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090622143231.3927.1495.stgit@warthog.procyon.org.uk>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 22, 2009 at 03:32:31PM +0100, David Howells wrote:
> In asm-generic/vmlinux.lds.h, name INIT_RAM_FS consistently, no matter the
> setting of CONFIG_BLK_DEV_INITRD.  This corrects:
> 
> 	commit ef53dae8658cf0e93d380983824a661067948d87
> 	Author: Sam Ravnborg <sam@ravnborg.org>
> 	Date:   Sun Jun 7 20:46:37 2009 +0200
> 	Subject: Improve vmlinux.lds.h support for arch specific linker scripts
> 
> Signed-off-by: David Howells <dhowells@redhat.com>
> Cc: Sam Ravnborg <sam@ravnborg.org>
Thanks for fixing this!

Acked-by: Sam Ravnborg <sam@ravnborg.org>

	Sam
