Return-Path: <linux-kernel-owner+w=401wt.eu-S934550AbXGSVc6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934550AbXGSVc6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 17:32:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934090AbXGSVcf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 17:32:35 -0400
Received: from barikada.upol.cz ([158.194.242.200]:40458 "EHLO
	barikada.upol.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934045AbXGSVce (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 17:32:34 -0400
Cc: linux-kernel@vger.kernel.org
To: rusty@rustcorp.com.au, ak@suse.de, akpm@linux-foundation.org
Subject: Re: - lguest-the-asm-offsets.patch removed from -mm tree
In-Reply-To: <200707192004.l6JK4wQK019993@imap1.linux-foundation.org>
References: <200707192004.l6JK4wQK019993@imap1.linux-foundation.org>
User-Agent: slrn + jed (x86_64-pc-linux-glibc-debian)
Date: Thu, 19 Jul 2007 23:46:05 +0200
Message-Id: <E1IBdoz-0005Ol-6b@flower>
From: Oleg Verych <olecom@flower.upol.cz>
Organization: Palacky University in Olomouc, experimental physics department
X-OS: x86_64-pc-linux-glibc-debian
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> This is the structure offsets required by lg.ko's switcher.S.
>
> Unfortunately we don't have infrastructure for private asm-offsets
> creation.

I did asm-offsets build rewrite RFC caled asm-values more than four week
ago: <http://mid.gmane.org/20070612234558.648949000@flower.upol.cz>

Just FYI.
____
