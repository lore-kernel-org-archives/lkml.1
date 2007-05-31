Return-Path: <linux-kernel-owner+w=401wt.eu-S1759380AbXEaIJl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759380AbXEaIJl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 04:09:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754088AbXEaIJH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 04:09:07 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:1546 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752843AbXEaIJE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 04:09:04 -0400
Date: Thu, 31 May 2007 18:08:06 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Maximilian Engelhardt <maxi@daemonizer.de>, nigel@nigel.suspend2.net,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Pavel Machek <pavel@ucw.cz>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: software suspend doesn't work with 2.6.22-rc3
Message-ID: <20070531080806.GA1055@gondor.apana.org.au>
References: <200705261128.57332.maxi@daemonizer.de> <200705310854.52490.rjw@sisk.pl> <200705310904.47894.rjw@sisk.pl> <200705310913.45234.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200705310913.45234.rjw@sisk.pl>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 31, 2007 at 09:13:44AM +0200, Rafael J. Wysocki wrote:
>
> From: Rafael J. Wysocki <rjw@sisk.pl>
> 
> Make cryptd actually run and mark it as nonfreezable.
> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>

Patch applied.  Thanks a lot!
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
