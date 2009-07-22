Return-Path: <linux-kernel-owner+w=401wt.eu-S1755290AbZGVXV1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755290AbZGVXV1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 19:21:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754803AbZGVXV1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 19:21:27 -0400
Received: from cantor.suse.de ([195.135.220.2]:33022 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754485AbZGVXV0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 19:21:26 -0400
Date: Thu, 23 Jul 2009 01:21:25 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jkosina@wotan.suse.de
To: =?ISO-8859-15?Q?N=E9meth_M=E1rton?= <nm127@freemail.hu>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] gcov: fix typo in CONFIG_DEBUG_FS
In-Reply-To: <4A677A27.30203@freemail.hu>
Message-ID: <alpine.LNX.2.00.0907230121160.11648@wotan.suse.de>
References: <4A677A27.30203@freemail.hu>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="168427776-1611694245-1248304886=:11648"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--168427776-1611694245-1248304886=:11648
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Wed, 22 Jul 2009, Németh Márton wrote:

> From: Márton Németh <nm127@freemail.hu>
> 
> The correct name is CONFIG_DEBUG_FS, add the missing underscore.
> 
> Signed-off-by: Márton Németh <nm127@freemail.hu>
> ---
> --- linux-2.6.31-rc3/Documentation/gcov.txt.orig	2009-07-20 19:56:05.000000000 +0200
> +++ linux-2.6.31-rc3/Documentation/gcov.txt	2009-07-21 22:53:20.000000000 +0200
> @@ -47,7 +47,7 @@
> 
>  Configure the kernel with:
> 
> -        CONFIG_DEBUGFS=y
> +        CONFIG_DEBUG_FS=y
>          CONFIG_GCOV_KERNEL=y

Applied to trivial queue, thanks.

-- 
Jiri Kosina
SUSE Labs
--168427776-1611694245-1248304886=:11648--
