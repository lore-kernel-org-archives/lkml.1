Return-Path: <linux-kernel-owner+w=401wt.eu-S932579AbXGLPJg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932579AbXGLPJg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 11:09:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757069AbXGLPJ2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 11:09:28 -0400
Received: from main.gmane.org ([80.91.229.2]:35682 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756507AbXGLPJ2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 11:09:28 -0400
X-Injected-Via-Gmane: http://gmane.org/
Mail-Followup-To: linux-kernel@vger.kernel.org
To: linux-kernel@vger.kernel.org
From: Oleg Verych <for.gmane@flower.upol.cz>
Subject: Re: [PATCH] mkmakefile: include ARCH on O= builds
Date: Thu, 12 Jul 2007 15:09:11 +0000 (UTC)
Organization: Palacky University in Olomouc, experimental physics department.
Message-ID: <slrnf9chpn.l6.for.gmane@flower.upol.cz>
References: <Pine.LNX.4.58.0707120331530.28774@be1.lrz>
X-Complaints-To: usenet@sea.gmane.org
X-Gmane-NNTP-Posting-Host: flower.upol.cz
Mail-Copies-To: never
X-User-Agent: slrn + jed (x86_64-pc-linux-glibc-debian)
User-Agent: slrn/0.9.8.1pl1 (Debian)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Bodo Eggert "Thu, 12 Jul 2007 03:40:04 +0200 (CEST)"

> If you build using O=builddir ARCH=bar, you'll currently need to supply
> ARCH= on builds from the builddir, too. With this patch, the generated
> Makefile will do that instead.

I've sent such thing at least twice.

But now i'm thinking about kbuild/kconfig rewrite instead.

> make ARCH= will still override the Makefile default, allowing existing 
> scripts to work correctly.
>
> Signed-Off-By: Bodo Eggert <7eggert@gmx.de>
____

