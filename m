Return-Path: <linux-kernel-owner+w=401wt.eu-S1753779AbZKAWDl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753779AbZKAWDl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Nov 2009 17:03:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753651AbZKAWDk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Nov 2009 17:03:40 -0500
Received: from mail-out2.uio.no ([129.240.10.58]:52864 "EHLO mail-out2.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753548AbZKAWDk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Nov 2009 17:03:40 -0500
Subject: Re: linux-next: nfs/nfsd trees fetch failed
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: "J. Bruce Fields" <bfields@fieldses.org>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20091102085835.651ddd02.sfr@canb.auug.org.au>
References: <20091102085835.651ddd02.sfr@canb.auug.org.au>
Content-Type: text/plain
Date: Sun, 01 Nov 2009 17:03:38 -0500
Message-Id: <1257113019.3916.6.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
X-UiO-Ratelimit-Test: rcpts/h 4 msgs/h 1 sum rcpts/h 5 sum msgs/h 1 total rcpts 1792 max rcpts/h 27 ratelimit 0
X-UiO-Spam-info: not spam, SpamAssassin (score=-5.0, required=5.0, autolearn=disabled, UIO_MAIL_IS_INTERNAL=-5, uiobl=NO, uiouri=NO)
X-UiO-Scanned: BCD79FC961F40F8195C7F8E9E36133C647C0602B
X-UiO-SPAM-Test: remote_host: 68.40.200.21 spam_score: -49 maxlevel 80 minaction 2 bait 0 mail/h: 1 total 13 max/h 2 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-11-02 at 08:58 +1100, Stephen Rothwell wrote:
> Hi all,
> 
> Today's fetch of the nfs and nfsd trees failed like this:
> 
> nfs: git
> git.linux-nfs.org[0: 141.212.112.37]: errno=Connection refused
> fatal: unable to connect a socket (Connection refused)
> nfsd: git
> git.linux-nfs.org[0: 141.212.112.37]: errno=Connection refused
> fatal: unable to connect a socket (Connection refused)
> 
> I will use the version of those trees from next-20091030.

Hi Stephen,

Yes. It's a known problem: an upgrade+reboot that went awry combined
with a remote console failure. I'm hoping that Bruce might be able to
help out when he returns to the office tomorrow morning...

Cheers
  Trond

