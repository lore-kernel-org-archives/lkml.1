Return-Path: <linux-kernel-owner+w=401wt.eu-S1758725AbXGKEr5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758725AbXGKEr5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 00:47:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752068AbXGKEru
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 00:47:50 -0400
Received: from [212.12.190.169] ([212.12.190.169]:32833 "EHLO raad.intranet"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752066AbXGKEru (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 00:47:50 -0400
From: Al Boldi <a1426z@gawab.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [RFC][Patch] Allow not mounting a root fs
Date: Wed, 11 Jul 2007 07:47:30 +0300
User-Agent: KMail/1.5
Cc: linux-kernel@vger.kernel.org
References: <200707081336.27985.a1426z@gawab.com> <4694287A.5080203@zytor.com>
In-Reply-To: <4694287A.5080203@zytor.com>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200707110747.30375.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> Al Boldi wrote:
> > Try this "[PATCH] initramfs: Allow rootfs to use tmpfs instead of
> > ramfs".
> >
> > It's trivial and should be in mainline.
>
> Simple, yes, trivial, no.
>
> It should be pushed to -mm before mainline to give it some smokeout time.

Great, maybe somebody can pick it up and adjust it for inclusion into -mm.


Thanks!

--
Al

