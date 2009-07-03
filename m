Return-Path: <linux-kernel-owner+w=401wt.eu-S1756172AbZGCAuU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756172AbZGCAuU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 20:50:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751628AbZGCAuJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 20:50:09 -0400
Received: from n16b.bullet.mail.mud.yahoo.com ([68.142.207.237]:29566 "HELO
	n16b.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751027AbZGCAuI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 20:50:08 -0400
X-Yahoo-Newman-Id: 318274.53372.bm@omp410.mail.mud.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=jqPqL7bAR99/67dZGiuWy8BpiBta40eZUGaltnG8f6A6endA9W5J7BTDRSgV1wLXHrVl4LQ2gdSZMBf7BBLsYh3ikVkTLgesF+DjwjnGUbJioo5m/5xbvG1A/VWMyPbkOj1h1H3QXlMD5fL29dJGwNY+ZB2kCGMOi7rN5nlxsac=  ;
X-YMail-OSG: W_q5XKMVM1lwUoCDfly9NGepqUkvFLY76Yk.7eRIlqu6M2tUUkG2iajEziHmbzKCnhRDncvqyOOWiuwE_n8FhFuJLPVEaX3sIaeezLJMRHtAN3OBhNFLnUWz7bniSKnzalMdcaaN12KnpPG41eMQgmsa9xsFk7_YANCUIZrMfyRjTvT7qF3ctCN2JGxrktbjW6FfI6Px_82lyndqIKyVeU_vClYF558SE9JDTjEuPTAZ08gPnZ4ZHip11gLqfr1zb6LRbttBEFRoQk_t
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: spi-devel-general@lists.sourceforge.net
Subject: Re: [spi-devel-general] [PATCH] SST25L (non JEDEC) SPI Flash driver
Date: Thu, 2 Jul 2009 17:50:11 -0700
User-Agent: KMail/1.9.10
Cc: Linus Walleij <linus.ml.walleij@gmail.com>,
       Ryan Mallon <ryan@bluewatersys.com>, akpm@linux-foundation.org,
       David Woodhouse <dwmw2@infradead.org>,
       linux kernel <linux-kernel@vger.kernel.org>
References: <4A42BDF3.10901@bluewatersys.com> <63386a3d0906241708j1ecbf8acwe47f9dbefd504c00@mail.gmail.com>
In-Reply-To: <63386a3d0906241708j1ecbf8acwe47f9dbefd504c00@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907021750.11353.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 24 June 2009, Linus Walleij wrote:
> > It was suggested I send the following patch via you as David Woodhouse
> > is currently busy.
> 
> Actually it was David Brownell (the SPI maintainer) I was thinking of
> that was sort of busy lately, perhaps Woodhouse (the MTD maintainer)
> is less busy ... let's see.

It's an MTD patch so I'd expect it to go through the MTD tree... :)


