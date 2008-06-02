Return-Path: <linux-kernel-owner+w=401wt.eu-S1752149AbYFBKEs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752149AbYFBKEs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 06:04:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756216AbYFBKEh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 06:04:37 -0400
Received: from ns2.suse.de ([195.135.220.15]:45476 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752391AbYFBKEg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 06:04:36 -0400
From: Andreas Gruenbacher <agruen@suse.de>
To: Christoph Hellwig <hch@infradead.org>
Subject: Re: [patch 01/15] security: pass path to inode_create
Date: Mon, 2 Jun 2008 12:04:13 +0200
User-Agent: KMail/1.9.51 (KDE/4.0.4; ; )
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-security-module@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, jmorris@namei.org, sds@tycho.nsa.gov,
       eparis@redhat.com, casey@schaufler-ca.com, jjohansen@suse.de,
       penguin-kernel@i-love.sakura.ne.jp, viro@zeniv.linux.org.uk,
       linux-kernel@vger.kernel.org
References: <20080529134903.615127628@szeredi.hu> <E1K343a-0002dG-C9@pomaz-ex.szeredi.hu> <20080602091341.GA8011@infradead.org>
In-Reply-To: <20080602091341.GA8011@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
X-Length: 1771
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200806021204.16615.agruen@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 02 June 2008 11:13:41 Christoph Hellwig wrote:
> On Mon, Jun 02, 2008 at 09:02:14AM +0200, Miklos Szeredi wrote:
> > So again, can you offer an alternative?
>
> Just give up on this dumb idea completely.

The AppArmor guys have really gone a long way in arguing their case, and all 
discussions so far have ended in you decreeing that pathnames are bad at some 
point. Thanks a lot for your constructive input on other areas of the code, 
but could you please come up with technical arguments why pathnames are 
bad this time?

Thanks a lot!

Andreas
