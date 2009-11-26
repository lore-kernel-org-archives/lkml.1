Return-Path: <linux-kernel-owner+w=401wt.eu-S1753131AbZKZWab@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753131AbZKZWab (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 17:30:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752892AbZKZWaa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 17:30:30 -0500
Received: from mail-out1.uio.no ([129.240.10.57]:33817 "EHLO mail-out1.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752035AbZKZWa3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 17:30:29 -0500
References: <20091127083936.b9c125c6.sfr@canb.auug.org.au>
Message-Id: <E8E998D0-13B9-4D54-AA55-FAF8EC72168B@fys.uio.no>
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Stephen Rothwell <sfr@canb.auug.org.au>
In-Reply-To: <20091127083936.b9c125c6.sfr@canb.auug.org.au>
Content-Type: text/plain;
	charset=us-ascii;
	format=flowed;
	delsp=yes
Content-Transfer-Encoding: 7bit
X-Mailer: iPhone Mail (7D11)
Mime-Version: 1.0 (iPhone Mail 7D11)
Subject: Re: linux-next: nfs/nfsd trees fetch failed
Date: Thu, 26 Nov 2009 17:30:22 -0500
Cc: "J. Bruce Fields" <bfields@fieldses.org>,
       "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
X-UiO-Ratelimit-Test: rcpts/h 4 msgs/h 1 sum rcpts/h 7 sum msgs/h 2 total rcpts 1960 max rcpts/h 27 ratelimit 0
X-UiO-Spam-info: not spam, SpamAssassin (score=-5.0, required=5.0, autolearn=disabled, UIO_MAIL_IS_INTERNAL=-5, uiobl=NO, uiouri=NO)
X-UiO-Scanned: 79E50C2CB6EB87F25153C42F41AC98D3BC238A4D
X-UiO-SPAM-Test: remote_host: 68.40.206.115 spam_score: -49 maxlevel 80 minaction 2 bait 0 mail/h: 1 total 18 max/h 3 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Nov 26, 2009, at 16:39, Stephen Rothwell <sfr@canb.auug.org.au>  
wrote:

> Hi all,
>
> Today's linux-next fetch of the nfs and nfsd trees produced this  
> error:
>
> git.linux-nfs.org[0: 141.212.112.37]: errno=Connection timed out
> fatal: unable to connect a socket (Connection timed out)
>
> This also happened yesterday.
>
> I will use the version of these trees from next-20091125 for today.

Hi Stephen,

Yes, I'm aware of the problem, and I'm sorry. I'm hoping that I can  
get Linux-nfs.org up and running again tomorrow (== Saturday your  
time) after the Thanksgiving celebrations.

Cheers
    Trond
