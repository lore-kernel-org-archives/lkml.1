Return-Path: <linux-kernel-owner+w=401wt.eu-S1758962AbYFDNXx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758962AbYFDNXx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 09:23:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752774AbYFDNXo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 09:23:44 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:39552 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751637AbYFDNXn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 09:23:43 -0400
To: mtk.manpages@googlemail.com
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, hch@lst.de,
       miklos@szeredi.hu, viro@zeniv.linux.org.uk, jamie@shareable.org,
       drepper@redhat.com, linux-fsdevel@vger.kernel.org,
       subrata@linux.vnet.ibm.com
In-reply-to: <484694C1.7030603@gmail.com> (message from Michael Kerrisk on
	Wed, 04 Jun 2008 15:12:33 +0200)
Subject: Re: [patch 0/4 v2] vfs: fix utimensat() non-conformances to spec
References: <484694C1.7030603@gmail.com>
Message-Id: <E1K3sxT-0000hy-9Z@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 04 Jun 2008 15:23:19 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This patch series is a revised version of the patch series
> that I sent yesterday to fix various utimensat()
> non-conformances.  Patches 1 and 2 are unchanged (and were
> Acked by Miklos); patches 3 and 4 are revised following
> comments by Miklos.
> 
> As requested I've split the original patch
> ("utimensat() non-conformances and fixes [v4] (patch)";
> http://article.gmane.org/gmane.linux.file-systems/24325 )
> into four parts.  Ideally, these should be applied for
> 2.6.26-rc, for the reasons outlined in my earlier mail
> "utimensat() non-conformances and fixes [v4] (test results)",
> http://article.gmane.org/gmane.linux.kernel/689411/ .
> 
> The four patches can be applied independently, except that
> patch 3 needs patch 2 to be applied first.

ACK for all four patches.

In patch 3/4 the indentation of that big "if" looks really horribly
broken, but it will be cleaned out completely, so I won't complain...

Miklos
