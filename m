Return-Path: <linux-kernel-owner+w=401wt.eu-S1754430AbYGYOv1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754430AbYGYOv1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 10:51:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753810AbYGYOul
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 10:50:41 -0400
Received: from mba.ocn.ne.jp ([122.1.235.107]:63068 "EHLO smtp.mba.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754743AbYGYOuk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 10:50:40 -0400
Date: Fri, 25 Jul 2008 23:52:33 +0900 (JST)
Message-Id: <20080725.235233.130241768.anemo@mba.ocn.ne.jp>
To: jason.wessel@windriver.com
Cc: linux-kernel@vger.kernel.org, ralf@linux-mips.org,
       linux-mips@linux-mips.org
Subject: Re: [PATCH 2/3] kgdb, mips: add arch support for the kernel's kgdb
 core
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
In-Reply-To: <488941C5.9060908@windriver.com>
References: <1216400928-29097-3-git-send-email-jason.wessel@windriver.com>
	<20080725.012748.108121457.anemo@mba.ocn.ne.jp>
	<488941C5.9060908@windriver.com>
X-Fingerprint: 6ACA 1623 39BD 9A94 9B1A  B746 CA77 FE94 2874 D52F
X-Pgp-Public-Key: http://wwwkeys.pgp.net/pks/lookup?op=get&search=0x2874D52F
X-Mailer: Mew version 5.2 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Jul 2008 22:00:21 -0500, Jason Wessel <jason.wessel@windriver.com> wrote:
> It seem ok to me to try it.  Here is version 3 of the patch, which I was going to send to Ralf.

Thanks, it works for me with serial_txx9 kgdboc module.
---
Atsushi Nemoto
