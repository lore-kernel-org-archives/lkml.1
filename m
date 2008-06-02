Return-Path: <linux-kernel-owner+w=401wt.eu-S1754131AbYFBLf5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754131AbYFBLf5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 07:35:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752124AbYFBLfq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 07:35:46 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:46399 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751716AbYFBLfp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 07:35:45 -0400
To: matthew@wil.cx
CC: miklos@szeredi.hu, hch@infradead.org,
       linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       jmorris@namei.org, sds@tycho.nsa.gov, eparis@redhat.com,
       casey@schaufler-ca.com, agruen@suse.de, jjohansen@suse.de,
       penguin-kernel@I-love.SAKURA.ne.jp, viro@ZenIV.linux.org.uk,
       linux-kernel@vger.kernel.org
In-reply-to: <20080602112350.GB8562@parisc-linux.org> (message from Matthew
	Wilcox on Mon, 2 Jun 2008 05:23:51 -0600)
Subject: Re: [patch 01/15] security: pass path to inode_create
References: <20080529134903.615127628@szeredi.hu> <20080529134958.655985182@szeredi.hu> <20080531083052.GH24135@infradead.org> <E1K2uXZ-0001eE-Oi@pomaz-ex.szeredi.hu> <20080602060144.GA11564@infradead.org> <E1K343a-0002dG-C9@pomaz-ex.szeredi.hu> <20080602112350.GB8562@parisc-linux.org>
Message-Id: <E1K38JN-0003H0-J9@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 02 Jun 2008 13:34:49 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > I maintain, that moving lsm hooks into callers is insane.  And that's
> > *the* sanest alternative that anybody has been able to come up with to
> > passing down vfsmounts into the vfs.
> 
> Not so.  I showed how pathname-based security could be done *without*
> passing vfsmounts down at all.  Unfortunately, you weren't interested.

Umm, not sure what you are referring to.  Could you please give a
pointer?  I'm sure the apparmor developers would be more than
interested in such a scheme, if it does indeed work.

Thanks,
Miklos
