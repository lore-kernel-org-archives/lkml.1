Return-Path: <linux-kernel-owner+w=401wt.eu-S965424AbXAXIHo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965424AbXAXIHo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jan 2007 03:07:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965391AbXAXIHo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jan 2007 03:07:44 -0500
Received: from topsns2.toshiba-tops.co.jp ([202.230.225.126]:37413 "EHLO
	topsns2.toshiba-tops.co.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965224AbXAXIHn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jan 2007 03:07:43 -0500
Date: Wed, 24 Jan 2007 17:07:36 +0900 (JST)
Message-Id: <20070124.170736.63741899.nemoto@toshiba-tops.co.jp>
To: akpm@osdl.org
Cc: sshtylyov@ru.mvista.com, Eric.Piel@lifl.fr, ralf@linux-mips.org,
       linux-kernel@vger.kernel.org, linux-mips@linux-mips.org
Subject: Re: [PATCH] Make CARDBUS_MEM_SIZE and CARDBUS_IO_SIZE customizable
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
In-Reply-To: <20070123235029.d49eda3d.akpm@osdl.org>
References: <20070123.103027.126140726.nemoto@toshiba-tops.co.jp>
	<20070123234507.08f63b5e.akpm@osdl.org>
	<20070123235029.d49eda3d.akpm@osdl.org>
X-Fingerprint: 6ACA 1623 39BD 9A94 9B1A  B746 CA77 FE94 2874 D52F
X-Pgp-Public-Key: http://wwwkeys.pgp.net/pks/lookup?op=get&search=0x2874D52F
X-Mailer: Mew version 3.3 on Emacs 21.3 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Jan 2007 23:50:29 -0800, Andrew Morton <akpm@osdl.org> wrote:
> > setup-bus.o is linked only on x86
> 
> oops, that's untrue.  But it will break ppc32, I think.

Oh sorry for confusion, I had updated wrong version of the patch when
applying comments from Eric and Sergei.

Final shape in mm tree looks fine.  Thank you.

---
Atsushi Nemoto
