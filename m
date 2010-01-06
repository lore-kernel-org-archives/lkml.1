Return-Path: <linux-kernel-owner+w=401wt.eu-S933038Ab0AFXKh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933038Ab0AFXKh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 18:10:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932940Ab0AFXKg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 18:10:36 -0500
Received: from mail-out1.uio.no ([129.240.10.57]:36511 "EHLO mail-out1.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932372Ab0AFXKf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 18:10:35 -0500
Subject: Re: [PATCH v2] sunrpc: fix build-time warning
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Jeff Layton <jlayton@redhat.com>, Stephen Rothwell <sfr@canb.auug.org.au>,
       linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org
In-Reply-To: <20100101182514.cb1f49ef.randy.dunlap@oracle.com>
References: <1262226195-27733-1-git-send-email-jlayton@redhat.com>
	 <20091231091815.a1ea7e51.rdunlap@xenotime.net>
	 <20091231205454.0f84f091@tupile.poochiereds.net>
	 <20100101182514.cb1f49ef.randy.dunlap@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 06 Jan 2010 18:10:20 -0500
Message-ID: <1262819420.4251.171.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 (2.28.2-1.fc12) 
Content-Transfer-Encoding: 7bit
X-UiO-Ratelimit-Test: rcpts/h 5 msgs/h 1 sum rcpts/h 10 sum msgs/h 1 total rcpts 2172 max rcpts/h 27 ratelimit 0
X-UiO-Spam-info: not spam, SpamAssassin (score=-5.0, required=5.0, autolearn=disabled, UIO_MAIL_IS_INTERNAL=-5, uiobl=NO, uiouri=NO)
X-UiO-Scanned: 8C895FF39F8FE5C3C00D69D8CA0E7772DFDBD9E4
X-UiO-SPAM-Test: remote_host: 68.40.206.115 spam_score: -49 maxlevel 80 minaction 2 bait 0 mail/h: 1 total 77 max/h 7 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-01-01 at 18:25 -0800, Randy Dunlap wrote: 
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Fix auth_gss printk format warning:
> 
> net/sunrpc/auth_gss/auth_gss.c:660: warning: format '%ld' expects type 'long int', but argument 3 has type 'ssize_t'
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>

Thanks Randy!

Sorry for the delay. This patch has been applied today, and should
therefore appear in the linux-next tree tomorrow...

Cheers
  Trond

