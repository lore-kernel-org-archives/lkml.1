Return-Path: <linux-kernel-owner+w=401wt.eu-S1755271AbXKEQyW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755271AbXKEQyW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 11:54:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750999AbXKEQyH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 11:54:07 -0500
Received: from iggypop2.siwnet.net ([81.216.65.12]:51278 "EHLO
	iggypop2.siwnet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753771AbXKEQyF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 11:54:05 -0500
From: Marcus Better <marcus@better.se>
To: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: 2.6.24-rc1: hangs when logging in to X session
Date: Mon, 5 Nov 2007 17:44:17 +0100
User-Agent: KMail/1.9.7
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
References: <fg4qau$9mg$1@ger.gmane.org> <20071105010308.6bd33fb1.akpm@linux-foundation.org> <20071105092632.GA10468@gondor.apana.org.au>
In-Reply-To: <20071105092632.GA10468@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711051744.17607.marcus@better.se>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Herbert Xu wrote:
> > > > > My laptop hangs when I try to log in to X with the current git
> > > > > kernel (commit 2a397e82c7db18019e408f953dd58dc1963a328c). It runs
> > > > > fine with 2.6.23. At boot time kdm starts normally, but hangs with
> > > > > the caps lock LED blinking immediately after I press Enter after
> > > > > typing the password.
>
> This was fixed after the changeset you quoted so if you update
> to the latest it should work again.

Yes, it works now. Thanks,

Marcus
