Return-Path: <linux-kernel-owner+w=401wt.eu-S933246AbXGaV2N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933246AbXGaV2N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 17:28:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932527AbXGaV1r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 17:27:47 -0400
Received: from pat.uio.no ([129.240.10.15]:35305 "EHLO pat.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933865AbXGaV1p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 17:27:45 -0400
Subject: Re: request for patches: showing mount options
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: chuck.lever@oracle.com
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, kzak@redhat.com, sfrench@samba.org,
       mark.fasheh@oracle.com, kurt.hackel@oracle.com
In-Reply-To: <46AFA6AB.8080208@oracle.com>
References: <E1IEQ7q-0000qE-00@dorka.pomaz.szeredi.hu>
	 <46AA4AC5.2050200@oracle.com> <E1IEW21-0001kL-00@dorka.pomaz.szeredi.hu>
	 <46AA51CA.7030105@oracle.com> <E1IEezF-0002g6-00@dorka.pomaz.szeredi.hu>
	 <46AE01C2.3000008@oracle.com> <E1IFnSa-0002BL-00@dorka.pomaz.szeredi.hu>
	 <46AF450D.5020106@oracle.com> <E1IFyEK-00042c-00@dorka.pomaz.szeredi.hu>
	 <46AFA6AB.8080208@oracle.com>
Content-Type: text/plain
Date: Tue, 31 Jul 2007 17:27:35 -0400
Message-Id: <1185917255.6700.80.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
X-UiO-Resend: resent
X-UiO-Spam-info: not spam, SpamAssassin (score=-0.1, required=12.0, autolearn=disabled, AWL=-0.095)
X-UiO-Scanned: DA9223DB494F0CB8F937DCAF99EF116D85AA8D72
X-UiO-SPAM-Test: remote_host: 129.240.10.9 spam_score: 0 maxlevel 200 minaction 2 bait 0 mail/h: 174 total 3038629 max/h 8345 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-07-31 at 17:16 -0400, Chuck Lever wrote:
> Miklos Szeredi wrote:
> > It would be nice to have all this stuff in 2.6.24, which doesn't leave
> > a lot of time.
> 
> Yes, that would be nice, but there's a lot of stuff that needs to get 
> done before this.  NFS IPv6, for example, is a higher priority than 
> refactoring to remove /etc/mtab -- the US government has a new 
> requirement in 2008 for IPv6 support in any software that it purchases, 
> and NFS may be a stumbling block for distributors if it doesn't have it.
> 
> So I'd say "no way" for 2.6.24, but it's really Trond's call to make.

I never like to tell people what their priorities should be. If someone
is interested enough to do the work, then it will get done, however this
cannot make the top of my already-overloaded list of priorities for
2.6.24, and it would appear that Chuck is busy too.

Any other volunteers out there?

Cheers
  Trond

