Return-Path: <linux-kernel-owner+w=401wt.eu-S1752263AbYGZPFg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752263AbYGZPFg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2008 11:05:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752170AbYGZPF3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jul 2008 11:05:29 -0400
Received: from mba.ocn.ne.jp ([122.1.235.107]:53779 "EHLO smtp.mba.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752158AbYGZPF3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2008 11:05:29 -0400
Date: Sun, 27 Jul 2008 00:07:21 +0900 (JST)
Message-Id: <20080727.000721.108121385.anemo@mba.ocn.ne.jp>
To: jason.wessel@windriver.com
Cc: linux-kernel@vger.kernel.org, linux-mips@linux-mips.org
Subject: Re: [PATCH] kgdb: kgdboc serial_txx9 I/O module
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
In-Reply-To: <488A0D6E.8090105@windriver.com>
References: <20080725.234914.41630045.anemo@mba.ocn.ne.jp>
	<488A0D6E.8090105@windriver.com>
X-Fingerprint: 6ACA 1623 39BD 9A94 9B1A  B746 CA77 FE94 2874 D52F
X-Pgp-Public-Key: http://wwwkeys.pgp.net/pks/lookup?op=get&search=0x2874D52F
X-Mailer: Mew version 5.2 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 Jul 2008 12:29:18 -0500, Jason Wessel <jason.wessel@windriver.com> wrote:
> > Implement the serial polling hooks for the serial_txx9 uart for use
> > with kgdboc.
> 
> Looks fine to me.
> 
> I pulled this into the kgdb-next branch, which I am working with Ralf to
> merge.

Thanks, excellent!

---
Atsushi Nemoto
