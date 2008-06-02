Return-Path: <linux-kernel-owner+w=401wt.eu-S1756104AbYFBJgw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756104AbYFBJgw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 05:36:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756723AbYFBJgc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 05:36:32 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:49306 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756493AbYFBJga (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 05:36:30 -0400
Date: Mon, 2 Jun 2008 05:36:30 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: hch@infradead.org, linux-security-module@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, jmorris@namei.org, sds@tycho.nsa.gov,
       eparis@redhat.com, casey@schaufler-ca.com, agruen@suse.de,
       jjohansen@suse.de, penguin-kernel@I-love.SAKURA.ne.jp,
       viro@ZenIV.linux.org.uk, linux-kernel@vger.kernel.org
Subject: Re: [patch 01/15] security: pass path to inode_create
Message-ID: <20080602093630.GA25254@infradead.org>
References: <20080529134903.615127628@szeredi.hu> <20080529134958.655985182@szeredi.hu> <20080531083052.GH24135@infradead.org> <E1K2uXZ-0001eE-Oi@pomaz-ex.szeredi.hu> <20080602060144.GA11564@infradead.org> <E1K343a-0002dG-C9@pomaz-ex.szeredi.hu> <20080602091341.GA8011@infradead.org> <E1K36PE-0002wZ-0M@pomaz-ex.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1K36PE-0002wZ-0M@pomaz-ex.szeredi.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 02, 2008 at 11:32:44AM +0200, Miklos Szeredi wrote:
> You act like a happy prince of VFS, but let me tell you one thing,
> there's only one king in this kingdom of Linux, and that's Linus
> Torvalds I.  And our wise king already said that apparmor can come, so
> the question is not "if" but "how".
> 
> If you don't want to help, that's a pity, but of course I don't want
> to (and can't) force you.  I can understand if personally you don't
> think this is a good idea, and don't want to have anything to do with
> it.  In that case I can leave you off the CC's for the parts which are
> not just generic VFS cleanups but explicitly towards apparmor
> integration.  Would that suit you?

No, and Agenda doesn't make these patches any better.

