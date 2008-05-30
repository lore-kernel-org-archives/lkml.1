Return-Path: <linux-kernel-owner+w=401wt.eu-S1753095AbYE3NiA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753095AbYE3NiA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 09:38:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751687AbYE3Nht
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 09:37:49 -0400
Received: from wine.ocn.ne.jp ([122.1.235.145]:59888 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750913AbYE3Nhs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 09:37:48 -0400
To: miklos@szeredi.hu
Cc: linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 00/15] security: pass path instead of inode to security ops
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <20080529134903.615127628@szeredi.hu>
In-Reply-To: <20080529134903.615127628@szeredi.hu>
Message-Id: <200805302237.BCH78170.FFMFSOOOJHQtLV@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.50 PL2]
X-Accept-Language: ja,en
Date: Fri, 30 May 2008 22:37:43 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Miklos Szeredi wrote:
> This is based on the vfs-cleanups(*) tree + the 8 patches posted
> recently (which will be added to this tree shortly).

Patching these 15 patches fails. I think this is because the 8 patches are missing.
Can I see the 8 patches?

  2 out of 4 hunks FAILED -- saving rejects to file include/linux/security.h.rej
  2 out of 3 hunks FAILED -- saving rejects to file include/linux/security.h.rej
  2 out of 4 hunks FAILED -- saving rejects to file include/linux/security.h.rej
  Reversed (or previously applied) patch detected!  Assume -R? [n]
  Apply anyway? [n]
  5 out of 5 hunks ignored -- saving rejects to file fs/namei.c.rej
  1 out of 4 hunks FAILED -- saving rejects to file include/linux/security.h.rej
  2 out of 4 hunks FAILED -- saving rejects to file include/linux/security.h.rej
  1 out of 2 hunks FAILED -- saving rejects to file mm/filemap.c.rej
  2 out of 4 hunks FAILED -- saving rejects to file include/linux/security.h.rej
  2 out of 5 hunks FAILED -- saving rejects to file include/linux/security.h.rej
  11 out of 12 hunks FAILED -- saving rejects to file fs/namei.c.rej
  2 out of 5 hunks FAILED -- saving rejects to file fs/namei.c.rej
  2 out of 4 hunks FAILED -- saving rejects to file include/linux/security.h.rej
  1 out of 3 hunks FAILED -- saving rejects to file security/selinux/hooks.c.rej

Regards.
