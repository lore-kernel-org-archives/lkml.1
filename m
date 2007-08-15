Return-Path: <linux-kernel-owner+w=401wt.eu-S934080AbXHORQS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934080AbXHORQS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 13:16:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755792AbXHORQG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 13:16:06 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:1716 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755506AbXHORQF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 13:16:05 -0400
Subject: Re: [PATCH] [525/2many] MAINTAINERS - USER-MODE LINUX
From: Joe Perches <joe@perches.com>
To: Jeff Dike <jdike@addtoit.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20070815143622.GC5376@c2.user-mode-linux.org>
References: <46bffc8f.k8F7SBEYGP7ozPij%joe@perches.com>
	 <20070815143622.GC5376@c2.user-mode-linux.org>
Content-Type: text/plain
Date: Wed, 15 Aug 2007 10:15:55 -0700
Message-Id: <1187198155.7443.12.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2-2.1mdv2007.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-08-15 at 10:36 -0400, Jeff Dike wrote:
> Looks fine, but add
> F:	fs/hostfs/
> F:	fs/hppfs/

Thanks, I've now got:

USER-MODE LINUX
P:	Jeff Dike
M:	jdike@karaya.com
L:	user-mode-linux-devel@lists.sourceforge.net
L:	user-mode-linux-user@lists.sourceforge.net
W:	http://user-mode-linux.sourceforge.net
S:	Maintained
F:	Documentation/uml/UserModeLinux-HOWTO.txt
F:	arch/um/
F:	include/asm-um/
F:	fs/hostfs/
F:	fs/hppfs/


