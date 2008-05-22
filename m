Return-Path: <linux-kernel-owner+w=401wt.eu-S933808AbYEVHNP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933808AbYEVHNP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 03:13:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754496AbYEVHMy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 03:12:54 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:43957 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758723AbYEVHMw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 03:12:52 -0400
To: viro@ZenIV.linux.org.uk
CC: miklos@szeredi.hu, linux-fsdevel@vger.kernel.org, hch@infradead.org,
       linux-kernel@vger.kernel.org
In-reply-to: <E1Jz4n9-00079l-Ub@pomaz-ex.szeredi.hu> (message from Miklos
	Szeredi on Thu, 22 May 2008 09:00:47 +0200)
Subject: Re: [patch 07/14] vfs: pass dentry to permission()
References: <20080521171458.077908538@szeredi.hu> <20080521171551.453155765@szeredi.hu> <20080521202914.GP28946@ZenIV.linux.org.uk> <E1Jz4n9-00079l-Ub@pomaz-ex.szeredi.hu>
Message-Id: <E1Jz4ym-0007B4-ON@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 22 May 2008 09:12:48 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I have a patch series that does it, but it involves tons of fixing the
> sysctl handling to be finished ;-/

Btw, could you please make this unfinished series available somewhere?
A tarball on hera or whatever.

Thanks,
Miklos
