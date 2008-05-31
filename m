Return-Path: <linux-kernel-owner+w=401wt.eu-S1754653AbYEaAdp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754653AbYEaAdp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 20:33:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752219AbYEaAdd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 20:33:33 -0400
Received: from wine.ocn.ne.jp ([122.1.235.145]:65039 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752019AbYEaAd2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 20:33:28 -0400
To: miklos@szeredi.hu
Cc: linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 00/15] security: pass path instead of inode to security ops
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <20080529134903.615127628@szeredi.hu>
	<200805302237.BCH78170.FFMFSOOOJHQtLV@I-love.SAKURA.ne.jp>
	<E1K28EM-0002L0-RT@pomaz-ex.szeredi.hu>
In-Reply-To: <E1K28EM-0002L0-RT@pomaz-ex.szeredi.hu>
Message-Id: <200805310933.HBB04640.FVQJLOHFtOSOFM@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.50 PL2]
X-Accept-Language: ja,en
Date: Sat, 31 May 2008 09:33:24 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Miklos Szeredi wrote:
> > > This is based on the vfs-cleanups(*) tree + the 8 patches posted
> > > recently (which will be added to this tree shortly).
> > 
> > Patching these 15 patches fails. I think this is because the 8
> > patches are missing.  Can I see the 8 patches?
> 
> I've now committed those to the vfs-cleanups tree.
> 
All 15 patches successfully applied on vfs-cleanups tree.

And I verified that these 15 patches also satisfy all modifications needed by TOMOYO Linux.
http://svn.sourceforge.jp/cgi-bin/viewcvs.cgi/trunk/2.2.x/tomoyo-lsm/patches/?rev=1251&root=tomoyo

Please go ahead. Thank you.
