Return-Path: <linux-kernel-owner+w=401wt.eu-S1758119AbYFBHCu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758119AbYFBHCu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 03:02:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752973AbYFBHCl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 03:02:41 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:53853 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752781AbYFBHCk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 03:02:40 -0400
To: hch@infradead.org
CC: miklos@szeredi.hu, hch@infradead.org,
       linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       jmorris@namei.org, sds@tycho.nsa.gov, eparis@redhat.com,
       casey@schaufler-ca.com, agruen@suse.de, jjohansen@suse.de,
       penguin-kernel@I-love.SAKURA.ne.jp, viro@ZenIV.linux.org.uk,
       linux-kernel@vger.kernel.org
In-reply-to: <20080602060144.GA11564@infradead.org> (message from Christoph
	Hellwig on Mon, 2 Jun 2008 02:01:44 -0400)
Subject: Re: [patch 01/15] security: pass path to inode_create
References: <20080529134903.615127628@szeredi.hu> <20080529134958.655985182@szeredi.hu> <20080531083052.GH24135@infradead.org> <E1K2uXZ-0001eE-Oi@pomaz-ex.szeredi.hu> <20080602060144.GA11564@infradead.org>
Message-Id: <E1K343a-0002dG-C9@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 02 Jun 2008 09:02:14 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > If you haven't noticed, I don't take "no" for an answer,
> 
> And now please tell us step 2 in your secret plan to win friends and
> influence.

WTF are you getting at?  You think kernel development is about
boot-licking instead of standing by your technical arguments?  What
have you been smoking lately?

I maintain, that moving lsm hooks into callers is insane.  And that's
*the* sanest alternative that anybody has been able to come up with to
passing down vfsmounts into the vfs.

So again, can you offer an alternative?

I *am* genuinely interested, so any ideas from anybody wanting to help
resolve this issue are welcome.

Thanks,
Miklos
