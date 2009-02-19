Return-Path: <linux-kernel-owner+w=401wt.eu-S1754958AbZBSNd3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754958AbZBSNd3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 08:33:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751597AbZBSNdR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 08:33:17 -0500
Received: from rhun.apana.org.au ([64.62.148.172]:54735 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751505AbZBSNdQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 08:33:16 -0500
Date: Thu, 19 Feb 2009 21:32:48 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Brian Haley <brian.haley@hp.com>
Cc: davem@davemloft.net, yoshfuji@linux-ipv6.org, vladislav.yasevich@hp.com,
       chuck.lever@oracle.com, tytso@mit.edu, Valdis.Kletnieks@vt.edu,
       arvidjaar@mail.ru, rjw@sisk.pl, netdev@vger.kernel.org,
       bonding-devel@lists.sourceforge.net, jamagallon@ono.com,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.29 regression? Bonding tied to IPV6 in 29-rc5
Message-ID: <20090219133248.GA11181@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <499C681A.6000008@hp.com>
Organization: Core
X-Newsgroups: apana.lists.os.linux.kernel,apana.lists.os.linux.netdev
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Brian Haley <brian.haley@hp.com> wrote:
> 
> There does seem to be a sysctl for it, just doesn't seem to work. 

OK we should definitely fix that.

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
