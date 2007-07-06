Return-Path: <linux-kernel-owner+w=401wt.eu-S1761276AbXGFMTg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761276AbXGFMTg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 08:19:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759965AbXGFMT1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 08:19:27 -0400
Received: from moutng.kundenserver.de ([212.227.126.174]:59770 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759637AbXGFMTZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 08:19:25 -0400
Date: Fri, 6 Jul 2007 14:17:51 +0200 (CEST)
From: Bodo Eggert <7eggert@gmx.de>
To: DervishD <lkml@dervishd.net>
cc: Bodo Eggert <7eggert@gmx.de>, Nix <nix@esperi.org.uk>,
       Karel Zak <kzak@redhat.com>,
       List util-linux-ng <util-linux-ng@vger.kernel.org>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [ANNOUNCE] util-linux-ng 2.13-rc1
In-Reply-To: <20070705192002.GB11204@DervishD>
Message-ID: <Pine.LNX.4.58.0707061406090.2241@be1.lrz>
References: <8CYT9-4Ou-23@gated-at.bofh.it> <8Dh9k-8lT-3@gated-at.bofh.it>
 <8DtDz-3xC-15@gated-at.bofh.it> <E1I6SfW-0002XG-AM@be1.lrz>
 <20070705192002.GB11204@DervishD>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
X-Provags-ID: V01U2FsdGVkX1/ALu1yPCRiQS4syxVEBgIVbvuyAnBUkXIMw6p
 DHdq34eVnKuhB35FJUOLpwlN5BQLPrPln7hKi+6luZRL7x1ICk
 jO5/Ja60g87XclRk++MKw==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 5 Jul 2007, DervishD wrote:
>  * Bodo Eggert <7eggert@gmx.de> dixit:

> > Standardisation is good, but autotools (as they are used) usurally isn't.
> 
>     Usually, by picking other's project configure.in and tweak blindly.

If it were that easy to write a correct automake script, people would do 
that. Wouldn't they?

> > Configuring the build of an autotools program is harder than nescensary;
> > if it used a config file, you could easily save it somewhere while adding
> > comments on how and why you did *that* choice, and you could possibly
> > use a set of default configs which you'd just include.
> 
>     Looks like CMake...

Obviously something I should look at.
-- 
Top 100 things you don't want the sysadmin to say:
45. Was that YOUR directory?
