Return-Path: <linux-kernel-owner+w=401wt.eu-S1753371AbYE3RRr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753371AbYE3RRr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 13:17:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752019AbYE3RRe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 13:17:34 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:36920 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751542AbYE3RRd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 13:17:33 -0400
To: penguin-kernel@I-love.SAKURA.ne.jp
CC: miklos@szeredi.hu, linux-security-module@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
In-reply-to: <200805302237.BCH78170.FFMFSOOOJHQtLV@I-love.SAKURA.ne.jp>
	(message from Tetsuo Handa on Fri, 30 May 2008 22:37:43 +0900)
Subject: Re: [patch 00/15] security: pass path instead of inode to security ops
References: <20080529134903.615127628@szeredi.hu> <200805302237.BCH78170.FFMFSOOOJHQtLV@I-love.SAKURA.ne.jp>
Message-Id: <E1K28EM-0002L0-RT@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Fri, 30 May 2008 19:17:30 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > This is based on the vfs-cleanups(*) tree + the 8 patches posted
> > recently (which will be added to this tree shortly).
> 
> Patching these 15 patches fails. I think this is because the 8
> patches are missing.  Can I see the 8 patches?

I've now committed those to the vfs-cleanups tree.

Thanks,
Miklos
