Return-Path: <linux-kernel-owner+w=401wt.eu-S1755988AbYFBLOd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755988AbYFBLOd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 07:14:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753690AbYFBLOG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 07:14:06 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:40838 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751637AbYFBLOE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 07:14:04 -0400
To: penberg@cs.helsinki.fi
CC: miklos@szeredi.hu, hch@infradead.org,
       linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       jmorris@namei.org, sds@tycho.nsa.gov, eparis@redhat.com,
       casey@schaufler-ca.com, agruen@suse.de, jjohansen@suse.de,
       penguin-kernel@i-love.sakura.ne.jp, viro@zeniv.linux.org.uk,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org
In-reply-to: <84144f020806020404v430e63c6i71cafdda616a2512@mail.gmail.com>
	(penberg@cs.helsinki.fi)
Subject: Re: [patch 01/15] security: pass path to inode_create
References: <20080529134903.615127628@szeredi.hu>
	 <E1K2uXZ-0001eE-Oi@pomaz-ex.szeredi.hu>
	 <20080602060144.GA11564@infradead.org>
	 <E1K343a-0002dG-C9@pomaz-ex.szeredi.hu>
	 <20080602091341.GA8011@infradead.org>
	 <E1K36PE-0002wZ-0M@pomaz-ex.szeredi.hu>
	 <20080602093630.GA25254@infradead.org>
	 <E1K36ii-0002zj-Gn@pomaz-ex.szeredi.hu>
	 <20080602104203.GA21898@infradead.org>
	 <E1K37hN-00039y-5o@pomaz-ex.szeredi.hu> <84144f020806020404v430e63c6i71cafdda616a2512@mail.gmail.com>
Message-Id: <E1K37yx-0003DB-3x@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 02 Jun 2008 13:13:43 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > You can argue against the concept of apparmor itself, but you better
> > argue with Crispin, because I'm quite clueless about that part.  When
> > you've convinced him (and Linus (and Ubuntu, and SUSE, and Mandriva))
> > that apparmor is a stupid idea, then I'll give up.  Good luck with
> > that!
> 
> But then I guess you can just by-pass the VFS maintainers and send
> your patches directly to Andrew/Linus. Good luck with that! :-)

You know what?  I do think I'd stand a better chance, than Christoph
convincing Crispin :)

But no, that's not what I want to do.  I do think that the VFS
maintainers are intelligent poeple, who can be convinced that fighting
against apparmor is not going to help anyone, and get back to the
technical issues of "how".

Miklos
